# frozen_string_literal: true

require 'numo/narray'
require 'numo/pocketfft/version'
require 'numo/pocketfft/pocketfftext'

module Numo
  module Pocketfft
    module_function

    # Compute the 1-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex 1-dimensional input array.
    # @return [Numo::DComplex] Transformed data.
    def fft(a)
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1
      raw_fft(a, 0, inverse: false, real: false)
    end

    # Compute the 1-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex 1-dimensional input array.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifft(a)
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1
      raw_fft(a, 0, inverse: true, real: false)
    end

    # Compute the 2-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex 2-dimensional input array.
    # @return [Numo::DComplex] Transformed data.
    def fft2(a)
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2
      fftn(a)
    end

    # Compute the 2-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex 2-dimensional input array.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifft2(a)
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2
      ifftn(a)
    end

    # Compute the N-dimensional discrete Fourier Transform.
    # @param a [Numo::DFloat/Numo::DComplex] Real or complex input array with any-dimension.
    # @return [Numo::DComplex] Transformed data.
    def fftn(a)
      b = a.dup
      (0...b.ndim).to_a.reverse.each { |ax_id| b = raw_fft(b, ax_id, inverse: false, real: false) }
      b
    end

    # Compute the N-dimensional inverse discrete Fourier Transform.
    # @param a [Numo::DComplex] Complex input array with any-dimension.
    # @return [Numo::DComplex] Inversed transformed data.
    def ifftn(a)
      b = a.dup
      (0...b.ndim).to_a.each { |ax_id| b = raw_fft(b, ax_id, inverse: true, real: false) }
      b
    end

    # Compute the 1-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real 1-dimensional input array.
    # @return [Numo::DComplex] Transformed data.
    def rfft(a)
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1
      raw_fft(a, 0, inverse: false, real: true)
    end

    # Compute the inverse of the 1-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex 1-dimensional input array.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfft(a)
      raise ArgumentError, 'Expect input array to be one-dimensional.' unless a.ndim == 1
      raw_fft(a, 0, inverse: true, real: true)
    end

    # Compute the 2-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real 2-dimensional input array.
    # @return [Numo::DComplex] Transformed data.
    def rfft2(a)
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2
      rfftn(a)
    end

    # Compute the inverse of the 2-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex 2-dimensional input array.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfft2(a)
      raise ArgumentError, 'Expect input array to be two-dimensional.' unless a.ndim == 2
      irfftn(a)
    end

    # Compute the N-dimensional discrete Fourier Transform for real input.
    # @param a [Numo::DFloat] Real input array with any-dimension.
    # @return [Numo::DComplex] Transformed data.
    def rfftn(a)
      last_axis_id = a.ndim - 1
      b = raw_fft(a, last_axis_id, inverse: false, real: true)
      (0...last_axis_id).to_a.reverse.each { |ax_id| b = raw_fft(b, ax_id, inverse: false, real: false) }
      b
    end

    # Compute the inverse of the N-dimensional discrete Fourier Transform of real input.
    # @param a [Numo::DComplex] Complex input array with any-dimension.
    # @return [Numo::DFloat] Inverse transformed data.
    def irfftn(a)
      last_axis_id = a.ndim - 1
      b = a.dup
      (0...last_axis_id).to_a.each { |ax_id| b = raw_fft(b, ax_id, inverse: true, real: false) }
      raw_fft(b, last_axis_id, inverse: true, real: true)
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
            b_range = [true] * b.ndim
            b_range[-1] = 0...a.shape[-1]
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
