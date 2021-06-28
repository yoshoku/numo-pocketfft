# 0.3.1
- Fix version specifier of runtime dependencies.

# 0.3.0
- Add type declaration file: sig/numo/pocketfft.rbs
- Refactor to avoid generating unnecessary arrays.

# 0.2.2
- Fix bug that caused segmentation fault due to garbage collection ([#4](https://github.com/yoshoku/numo-pocketfft/pull/4)).
- Fix some configuration files.

# 0.2.1
- Fix the link to the document.
- Several documentation improvements.

# 0.2.0
- Add fftconvolve method that convolves two arrays with FFT.

# 0.1.1
- Add input validation for empty array.
- Add input validation for non-Numo::NArray object.
- Fix to raise NoMemoryError when happened memory allocation error.

# 0.1.0
- First release.
