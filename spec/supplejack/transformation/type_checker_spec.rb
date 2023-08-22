# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transformation::TypeChecker do
  describe '#check' do
    describe 'allowed types' do
      it 'returns true with NilClass' do
        expect(described_class.new(nil).valid?).to be true
      end

      it 'returns true with TrueClass' do
        expect(described_class.new(true).valid?).to be true
      end

      it 'returns true with FalseClass' do
        expect(described_class.new(false).valid?).to be true
      end

      it 'returns true with Integer' do
        expect(described_class.new(1).valid?).to be true
      end

      it 'returns true with Float' do
        expect(described_class.new(0.1).valid?).to be true
      end

      it 'returns true with String' do
        expect(described_class.new('String').valid?).to be true
      end

      it 'returns true with empty array' do
        expect(described_class.new([]).valid?).to be true
      end

      it 'returns true with empty Hash' do
        expect(described_class.new({}).valid?).to be true
      end

      it 'returns true with array of nil' do
        expect(described_class.new([nil, nil]).valid?).to be true
      end

      it 'returns true with array of TrueClass' do
        expect(described_class.new([true]).valid?).to be true
      end

      it 'returns true with array of FalseClass' do
        expect(described_class.new([false]).valid?).to be true
      end

      it 'returns true with array of Integer' do
        expect(described_class.new([1, 1]).valid?).to be true
      end

      it 'returns true with array of Float' do
        expect(described_class.new([0.1, 0.1]).valid?).to be true
      end

      it 'returns true with array of String' do
        expect(described_class.new(%w[String String]).valid?).to be true
      end

      it 'returns true with Hash of String => TrueClass' do
        expect(described_class.new('1' => true).valid?).to be true
      end

      it 'returns true with Hash of String => FalseClass' do
        expect(described_class.new('1' => false).valid?).to be true
      end

      it 'returns true with Hash of Integer => nil' do
        expect(described_class.new(1 => nil).valid?).to be true
      end

      it 'returns true with Hash of String => Integer' do
        expect(described_class.new('a' => 1).valid?).to be true
      end

      it 'returns true with Hash of Symbol => Integer' do
        expect(described_class.new(a: 1).valid?).to be true
      end

      it 'returns true with Hash of String => String' do
        expect(described_class.new('A' => 'B').valid?).to be true
      end
    end

    describe 'forbidden types' do
      it 'returns false with Object' do
        expect(described_class.new(Object.new).valid?).to be false
      end

      it 'returns false with Array of Object' do
        expect(described_class.new([Object.new]).valid?).to be false
      end

      it 'returns false with an Object in Hash key' do
        expect(described_class.new({Object.new => 1}).valid?).to be false
      end

      it 'returns false with an Object in Hash value' do
        expect(described_class.new({1 => Object.new}).valid?).to be false
      end
    end
  end
end
