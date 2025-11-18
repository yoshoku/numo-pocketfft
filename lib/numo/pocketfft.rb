# frozen_string_literal: true

require 'numo/narray/alt'
require 'numo/pocketfft/version'
require 'numo/pocketfft/pocketfftext'

module Numo
  module Pocketfft
    module_function

    # Compute the 1-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex 1-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not one-dimensional array, or is empty.
    # @return [Numo::DComplex] Transformed data.
    def fft(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1

      raw_fft(a, 0, inverse: false, real: false)
    end

    # Compute the 1-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex 1-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not one-dimensional array, or is empty.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifft(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1

      raw_fft(a, 0, inverse: true, real: false)
    end

    # Compute the 2-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex 2-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not two-dimensional array, or is empty.
    # @return [Numo::DComplex] Transformed data.
    def fft2(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2

      fftn(a)
    end

    # Compute the 2-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex 2-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not two-dimensional array, or is empty.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifft2(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2

      ifftn(a)
    end

    # Compute the N-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex input array with any-dimension.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray or is empty.
    # @return [Numo::DComplex] Transformed data.
    def fftn(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?

      return raw_fft(a, 0, inverse: false, real: false) if a.ndim == 1

      last_axis_id = a.ndim - 1
      b = raw_fft(a, last_axis_id, inverse: false, real: false)
      (last_axis_id - 1).downto(0) { |ax_id| b = raw_fft(b, ax_id, inverse: false, real: false) }
      b
    end

    # Compute the N-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex input array with any-dimension.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray or is empty.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifftn(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?

      return raw_fft(a, 0, inverse: true, real: false) if a.ndim == 1

      last_axis_id = a.ndim - 1
      b = raw_fft(a, 0, inverse: true, real: false)
      1.upto(last_axis_id) { |ax_id| b = raw_fft(b, ax_id, inverse: true, real: false) }
      b
    end

    # Compute the 1-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real 1-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not one-dimensional array, or is empty.
    # @return [Numo::DComplex] Transformed data.
    def rfft(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1

      raw_fft(a, 0, inverse: false, real: true)
    end

    # Compute the inverse of the 1-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex 1-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not one-dimensional array, or is empty.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfft(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1

      raw_fft(a, 0, inverse: true, real: true)
    end

    # Compute the 2-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real 2-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not two-dimensional array, or is empty.
    # @return [Numo::DComplex] Transformed data.
    def rfft2(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2

      rfftn(a)
    end

    # Compute the inverse of the 2-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex 2-dimensional input array.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray, is not two-dimensional array, or is empty.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfft2(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2

      irfftn(a)
    end

    # Compute the N-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real input array with any-dimension.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray or is empty.
    # @return [Numo::DComplex] Transformed data.
    def rfftn(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?

      return raw_fft(a, 0, inverse: false, real: true) if a.ndim == 1

      last_axis_id = a.ndim - 1
      b = raw_fft(a, last_axis_id, inverse: false, real: true)
      (last_axis_id - 1).downto(0) { |ax_id| b = raw_fft(b, ax_id, inverse: false, real: false) }
      b
    end

    # Compute the inverse of the N-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex input array with any-dimension.
    # @raise [ArgumentError] This error is raised if input array is not Numo::NArray or is empty.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfftn(a)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty?

      return raw_fft(a, 0, inverse: true, real: true) if a.ndim == 1

      last_axis_id = a.ndim - 1
      b = raw_fft(a, 0, inverse: true, real: false)
      1.upto(last_axis_id - 1) { |ax_id| b = raw_fft(b, ax_id, inverse: true, real: false) }
      raw_fft(b, last_axis_id, inverse: true, real: true)
    end

    # Convolve two N-dimensinal arrays using dscrete Fourier Transform.
    # @example
    #   require 'numo/pocketfftw'
    #
    #   a = Numo::DFloat[1, 2, 3]
    #   b = Numo::DFloat[4, 5]
    #   p Numo::Pocketfft.fftconvolve(a, b)
    #   # Numo::DFloat#shape=[4]
    #   # [4, 13, 22, 15]
    #
    #   a = Numo::DFloat[[1, 2], [3, 4]]
    #   b = Numo::DFloat[[5, 6], [7, 8]]
    #   p Numo::Pocketfft.fftconvolve(a, b)
    #   # Numo::DFloat#shape=[3,3]
    #   # [[5, 16, 12],
    #   #  [22, 60, 40],
    #   #  [21, 52, 32]]
    # @param a [Numo::DFloat/Numo::DComplex] Fisrt input array with any-dimension.
    # @param b [Numo::DFloat/Numo::DComplex] Second input array with the same number of dimensions as first input array.
    # @raise [ArgumentError] This error is raised if input arrays are not Numo::NArray, are not the same dimensionality, or are empty.
    # @return [Numo::DFloat/Numo::DComplex] The discrete linear convolution of 'a' with 'b'.
    def fftconvolve(a, b)
      raise ArgumentError, 'Expect class of input array to be Numo::NArray.' unless a.is_a?(Numo::NArray) && b.is_a?(Numo::NArray)
      raise ArgumentError, 'Expect input array to be non-empty.' if a.empty? || b.empty?
      raise ArgumentError, 'Input arrays should have the same dimensionarity' if a.ndim != b.ndim

      ashp = a.shape
      bshp = b.shape

      return a * b if (ashp + bshp).all? { |el| el == 1 }

      retshp = Array.new(a.ndim) { |n| ashp[n] + bshp[n] - 1 }
      a_zp = Numo::DComplex.zeros(*retshp).tap { |arr| arr[*ashp.map { |n| 0...n }] = a }
      b_zp = Numo::DComplex.zeros(*retshp).tap { |arr| arr[*bshp.map { |n| 0...n }] = b }
      ret = ifftn(fftn(a_zp) * fftn(b_zp))

      return ret if a.is_a?(Numo::DComplex) || a.is_a?(Numo::SComplex) || b.is_a?(Numo::DComplex) || b.is_a?(Numo::SComplex)

      ret.real
    end

    # @!visibility private
    def raw_fft(a, axis_id, inverse:, real:)
      if axis_id == a.ndim - 1
        if real
          if inverse
            # zero padding
            n = (a.shape[-1] - 1) * 2
            b_shape = a.shape
            b_shape[-1] = n
            b = Numo::DComplex.zeros(*b_shape)
            b_range = Array.new(b.ndim) { |idx| idx < b.ndim - 1 ? true : 0...a.shape[-1] }
            b[*b_range] = a
            # inverse of dft for real data
            ext_irfft(b)
          else
            ext_rfft(a)
          end
        else
          if inverse
            ext_icfft(a)
          else
            ext_cfft(a)
          end
        end
      else
        if inverse
          ext_icfft(a.swapaxes(axis_id, -1)).swapaxes(axis_id, -1).dup
        else
          ext_cfft(a.swapaxes(axis_id, -1)).swapaxes(axis_id, -1).dup
        end
      end
    end

    private_class_method :ext_cfft, :ext_icfft, :ext_rfft, :ext_irfft, :raw_fft
  end
end
