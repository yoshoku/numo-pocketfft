# 0.5.1

- Set the required version of numo-narray-alt to 0.9.9 or higher.
- Change require statement to explicitly load numo/narray/alt.

# 0.5.0

**Breaking change**

- Change dependency from numo-narray to [numo-narray-alt](https://github.com/yoshoku/numo-narray-alt).

# 0.4.1
- Fix build failure with Xcode 14 and Ruby 3.1.x.

# 0.4.0
- Refactor native extension codes with C99 style.
- Change not ot use git submodule for pocketfft codes bundle.
- Introduce conventional commits.

# 0.3.2
- Update type declaration file.
- Remove dependent gem's type declaration file from installation files.

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
