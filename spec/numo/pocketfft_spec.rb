# frozen_string_literal: true

RSpec.describe Numo::Pocketfft do
  let(:tol) { 1.0e-10 }
  let(:vec_dflt) { Numo::DFloat.new(30).rand }
  let(:vec_dcmp) { Numo::DFloat.new(30).rand + Complex::I * Numo::DFloat.new(30).rand }
  let(:mat_dflt) { Numo::DFloat.new(30, 20).rand }
  let(:mat_dcmp) { Numo::DFloat.new(30, 20).rand + Complex::I * Numo::DFloat.new(30, 20).rand }
  let(:tns_dflt) { Numo::DFloat.new(30, 20, 10).rand }
  let(:tns_dcmp) { Numo::DFloat.new(30, 20, 10).rand + Complex::I * Numo::DFloat.new(30, 20, 10).rand }

  it 'has a version number' do
    expect(Numo::Pocketfft::VERSION).not_to be nil
  end

  describe 'fft' do
    it 'computes the 1-d dft' do
      spect_a = described_class.fft(vec_dcmp)
      spect_b = fft1d(vec_dcmp)
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 1-dimensional array' do
      expect { described_class.fft(mat_dcmp) }.to raise_error(ArgumentError)
      expect { described_class.fft(tns_dcmp) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.fft(nil) }.to raise_error(ArgumentError)
      expect { described_class.fft(1) }.to raise_error(ArgumentError)
      expect { described_class.fft([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.fft(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'ifft' do
    it 'computes the inverse 1-d dft' do
      rec_vec_dcmp = described_class.ifft(described_class.fft(vec_dcmp))
      err = (rec_vec_dcmp - vec_dcmp).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 1-dimensional array' do
      expect { described_class.ifft(mat_dcmp) }.to raise_error(ArgumentError)
      expect { described_class.ifft(tns_dcmp) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.ifft(nil) }.to raise_error(ArgumentError)
      expect { described_class.ifft(1) }.to raise_error(ArgumentError)
      expect { described_class.ifft([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.ifft(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'fft2' do
    it 'computes the 2-d dft' do
      spect_a = described_class.fft2(mat_dcmp)
      spect_b = described_class.send(
        :raw_fft,
        described_class.send(
          :raw_fft, mat_dcmp,
          1, inverse: false, real: false
        ),
        0, inverse: false, real: false
      )
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 2-dimensional array' do
      expect { described_class.fft2(vec_dcmp) }.to raise_error(ArgumentError)
      expect { described_class.fft2(tns_dcmp) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.fft2(nil) }.to raise_error(ArgumentError)
      expect { described_class.fft2(1) }.to raise_error(ArgumentError)
      expect { described_class.fft2([[1, 2, 3], [4, 5, 6]]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.fft2(Numo::DFloat[[], []]) }.to raise_error(ArgumentError)
    end
  end

  describe 'ifft2' do
    it 'computes the inverse 2-d dft' do
      inv_spect_a = described_class.ifft2(mat_dcmp)
      inv_spect_b = described_class.send(
        :raw_fft,
        described_class.send(
          :raw_fft, mat_dcmp,
          1, inverse: true, real: false
        ),
        0, inverse: true, real: false
      )
      err = (inv_spect_a - inv_spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 2-dimensional array' do
      expect { described_class.ifft2(vec_dcmp) }.to raise_error(ArgumentError)
      expect { described_class.ifft2(tns_dcmp) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.ifft2(nil) }.to raise_error(ArgumentError)
      expect { described_class.ifft2(1) }.to raise_error(ArgumentError)
      expect { described_class.ifft2([[1, 2, 3], [4, 5, 6]]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.ifft2(Numo::DFloat[[], []]) }.to raise_error(ArgumentError)
    end
  end

  describe 'fftn' do
    it 'computes the 3-d dft' do
      spect_a = described_class.fftn(tns_dcmp)
      spect_b = described_class.send(
        :raw_fft,
        described_class.send(
          :raw_fft,
          described_class.send(
            :raw_fft, tns_dcmp,
            2, inverse: false, real: false
          ),
          1, inverse: false, real: false
        ),
        0, inverse: false, real: false
      )
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.fftn(nil) }.to raise_error(ArgumentError)
      expect { described_class.fftn(1) }.to raise_error(ArgumentError)
      expect { described_class.fftn([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.fftn(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'ifftn' do
    it 'computes the inverse 3-d dft' do
      inv_spect_a = described_class.ifftn(tns_dcmp)
      inv_spect_b = described_class.send(
        :raw_fft,
        described_class.send(
          :raw_fft,
          described_class.send(
            :raw_fft, tns_dcmp,
            2, inverse: true, real: false
          ),
          1, inverse: true, real: false
        ),
        0, inverse: true, real: false
      )
      err = (inv_spect_a - inv_spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.ifftn(nil) }.to raise_error(ArgumentError)
      expect { described_class.ifftn(1) }.to raise_error(ArgumentError)
      expect { described_class.ifftn([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.ifftn(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'rfft' do
    it 'computes the 1-d dft for real data' do
      spect_a = described_class.rfft(vec_dflt)
      spect_b = described_class.fft(vec_dflt)[0..15]
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 1-dimensional array' do
      expect { described_class.rfft(mat_dflt) }.to raise_error(ArgumentError)
      expect { described_class.rfft(tns_dflt) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.rfft(nil) }.to raise_error(ArgumentError)
      expect { described_class.rfft(1) }.to raise_error(ArgumentError)
      expect { described_class.rfft([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.rfft(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'irfft' do
    it 'computes the inverse 1-d dft of real data' do
      rec_vec_dflt = described_class.irfft(described_class.rfft(vec_dflt))
      err = (rec_vec_dflt - vec_dflt).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 1-dimensional array' do
      expect { described_class.irfft(mat_dflt) }.to raise_error(ArgumentError)
      expect { described_class.irfft(tns_dflt) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.irfft(nil) }.to raise_error(ArgumentError)
      expect { described_class.irfft(1) }.to raise_error(ArgumentError)
      expect { described_class.irfft([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.irfft(Numo::DFloat[]) }.to raise_error(ArgumentError)
    end
  end

  describe 'rfft2' do
    it 'computes the 2-d dft for real data' do
      spect_a = described_class.rfft2(mat_dflt)
      spect_b = described_class.fft2(mat_dflt)[true, 0..10]
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 2-dimensional array' do
      expect { described_class.rfft2(vec_dflt) }.to raise_error(ArgumentError)
      expect { described_class.rfft2(tns_dflt) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.rfft2(nil) }.to raise_error(ArgumentError)
      expect { described_class.rfft2(1) }.to raise_error(ArgumentError)
      expect { described_class.rfft2([[1, 2, 3], [4, 5, 6]]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.rfft2(Numo::DFloat[[], []]) }.to raise_error(ArgumentError)
    end
  end

  describe 'irfft2' do
    it 'computes the inverse 2-d dft of real data' do
      rec_mat_dflt = described_class.irfft2(described_class.rfft2(mat_dflt))
      err = (rec_mat_dflt - mat_dflt).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given non 2-dimensional array' do
      expect { described_class.irfft2(vec_dflt) }.to raise_error(ArgumentError)
      expect { described_class.irfft2(tns_dflt) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.irfft2(nil) }.to raise_error(ArgumentError)
      expect { described_class.irfft2(1) }.to raise_error(ArgumentError)
      expect { described_class.irfft2([[1, 2, 3], [4, 5, 6]]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.irfft2(Numo::DFloat[[], []]) }.to raise_error(ArgumentError)
    end
  end

  describe 'rfftn' do
    it 'computes the 3-d dft for real data' do
      spect_a = described_class.rfftn(tns_dflt)
      spect_b = described_class.fftn(tns_dflt)[true, true, 0...6]
      err = (spect_a - spect_b).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.rfftn(nil) }.to raise_error(ArgumentError)
      expect { described_class.rfftn(1) }.to raise_error(ArgumentError)
      expect { described_class.rfftn([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.rfftn([]) }.to raise_error(ArgumentError)
    end
  end

  describe 'irfftn' do
    it 'computes the inverse 3-d dft of real data' do
      rec_tns_dflt = described_class.irfftn(described_class.rfftn(tns_dflt))
      err = (rec_tns_dflt - tns_dflt).abs.sum
      expect(err).to be <= tol
    end

    it 'raises ArgumentError when given a non-Numo::NArray object' do
      expect { described_class.irfftn(nil) }.to raise_error(ArgumentError)
      expect { described_class.irfftn(1) }.to raise_error(ArgumentError)
      expect { described_class.irfftn([1, 2, 3]) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when given empty array' do
      expect { described_class.irfftn([]) }.to raise_error(ArgumentError)
    end
  end
end
