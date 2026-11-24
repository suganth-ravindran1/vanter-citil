import { useState, useEffect, useRef, useCallback } from 'react';

/**
 * useTruckFrames
 * Custom hook for progressive loading, decoding, and caching of truck 360 sequence frames.
 * Driven strictly by manifest.json.
 * 
 * @param {string} manifestUrl - Relative or absolute path to manifest.json
 */
export function useTruckFrames(manifestUrl = './assets/truck-360/manifest.json') {
  const [manifest, setManifest] = useState(null);
  const [posterImage, setPosterImage] = useState(null);
  const [loadedCount, setLoadedCount] = useState(0);
  const [totalFrames, setTotalFrames] = useState(0);
  const [isInitialReady, setIsInitialReady] = useState(false);
  const [isFullyLoaded, setIsFullyLoaded] = useState(false);
  const [error, setError] = useState(null);

  // In-memory cache for loaded and decoded HTMLImageElement instances (1-indexed)
  const framesCacheRef = useRef({});
  const activeDownloadsRef = useRef(new Set());
  const abortControllerRef = useRef(null);

  // Compute base directory from manifest URL (e.g., "./assets/truck-360/")
  const getBaseDir = useCallback((url) => {
    const lastSlash = url.lastIndexOf('/');
    return lastSlash !== -1 ? url.slice(0, lastSlash + 1) : './';
  }, []);

  // Safe frame retriever with fallback to nearest available frame or poster
  const getFrame = useCallback((frameIndex) => {
    const targetIdx = Math.max(1, Math.min(totalFrames || 110, Math.round(frameIndex)));
    const cache = framesCacheRef.current;

    // 1. Exact match in cache
    if (cache[targetIdx]) {
      return cache[targetIdx];
    }

    // 2. Nearest loaded frame search (radial outwards)
    let bestDist = Infinity;
    let fallback = null;
    for (const key in cache) {
      const idx = Number(key);
      const dist = Math.abs(idx - targetIdx);
      if (dist < bestDist) {
        bestDist = dist;
        fallback = cache[idx];
      }
    }

    if (fallback) {
      return fallback;
    }

    // 3. Fallback to poster image
    return posterImage;
  }, [totalFrames, posterImage]);

  useEffect(() => {
    abortControllerRef.current = new AbortController();
    const { signal } = abortControllerRef.current;
    let isCancelled = false;

    async function loadSequence() {
      try {
        setError(null);
        setLoadedCount(0);
        setIsInitialReady(false);
        setIsFullyLoaded(false);
        framesCacheRef.current = {};

        // 1. Fetch manifest.json
        const res = await fetch(manifestUrl, { signal });
        if (!res.ok) {
          throw new Error(`Failed to fetch manifest at "${manifestUrl}" (status ${res.status})`);
        }
        const data = await res.json();
        if (isCancelled) return;

        setManifest(data);
        const count = data.sequence?.total_frames || 110;
        setTotalFrames(count);

        const baseDir = getBaseDir(manifestUrl);
        const posterRel = data.sequence?.poster_path || 'poster.webp';
        const posterSrc = `${baseDir}${posterRel}`;

        // 2. Load & decode poster image immediately
        const poster = new Image();
        poster.crossOrigin = 'anonymous';
        poster.src = posterSrc;

        const posterLoadPromise = new Promise((resolve) => {
          poster.onload = async () => {
            try {
              if (poster.decode) await poster.decode();
            } catch (_) {}
            if (!isCancelled) {
              setPosterImage(poster);
              setIsInitialReady(true);
            }
            resolve(poster);
          };
          poster.onerror = () => {
            console.warn(`Poster image failed to load at "${posterSrc}". Proceeding to frame load.`);
            resolve(null);
          };
        });

        // 3. Helper to load and decode a single frame
        const loadFrame = (frameNum) => {
          return new Promise((resolve) => {
            if (isCancelled || framesCacheRef.current[frameNum]) {
              return resolve(framesCacheRef.current[frameNum] || null);
            }

            const frameFilename = `frame_${String(frameNum).padStart(4, '0')}.webp`;
            const frameSrc = `${baseDir}frames/${frameFilename}`;

            const img = new Image();
            img.crossOrigin = 'anonymous';
            img.src = frameSrc;

            img.onload = async () => {
              try {
                if (img.decode) await img.decode();
              } catch (_) {}
              if (!isCancelled) {
                framesCacheRef.current[frameNum] = img;
                setLoadedCount((prev) => {
                  const updated = Object.keys(framesCacheRef.current).length;
                  if (updated >= count) setIsFullyLoaded(true);
                  return updated;
                });
                if (frameNum === 1) setIsInitialReady(true);
              }
              resolve(img);
            };

            img.onerror = () => {
              console.warn(`Frame ${frameNum} failed to load from ${frameSrc}`);
              resolve(null);
            };
          });
        };

        // 4. Preload Phase: Load frame 1 + key milestone frames + first 10 frames
        await posterLoadPromise;
        if (isCancelled) return;

        const milestoneFrames = [1, 2, 3, 4, 5, 10, 36, 72, 98, 110].filter((n) => n <= count);
        await Promise.all(milestoneFrames.map((n) => loadFrame(n)));
        if (!isCancelled) {
          setIsInitialReady(true);
        }

        // 5. Progressive Background Loading for remaining frames with concurrency limit
        const remaining = [];
        for (let i = 1; i <= count; i++) {
          if (!framesCacheRef.current[i]) {
            remaining.push(i);
          }
        }

        const CONCURRENCY = 4;
        let index = 0;

        async function worker() {
          while (index < remaining.length && !isCancelled) {
            const frameToLoad = remaining[index++];
            await loadFrame(frameToLoad);
          }
        }

        const workers = Array.from({ length: CONCURRENCY }, () => worker());
        await Promise.all(workers);

        if (!isCancelled) {
          setIsFullyLoaded(true);
        }
      } catch (err) {
        if (!isCancelled && err.name !== 'AbortError') {
          console.error('Truck360 frame loader error:', err);
          setError(err.message || 'Error loading sequence');
        }
      }
    }

    loadSequence();

    return () => {
      isCancelled = true;
      if (abortControllerRef.current) {
        abortControllerRef.current.abort();
      }
    };
  }, [manifestUrl, getBaseDir]);

  const progressPercent = totalFrames > 0 ? Math.round((loadedCount / totalFrames) * 100) : 0;

  return {
    manifest,
    totalFrames,
    loadedCount,
    progressPercent,
    isInitialReady,
    isFullyLoaded,
    error,
    getFrame,
    milestones: manifest?.sequence?.key_milestones || [],
    orbitValidation: manifest?.sequence?.orbit_validation || null,
    frameDimensions: {
      width: manifest?.sequence?.width || 1920,
      height: manifest?.sequence?.height || 1080
    }
  };
}
