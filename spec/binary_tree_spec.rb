require 'rspec'
require './binary_tree'

RSpec.describe BinaryTree::Generator do
  let(:a) { BinaryTree::Generator.new(5,8,2,3,6,8,6,9,10,11,4) }

  describe 'correct data tests' do
    it 'is a correct tree' do
      expect(a.class).to eq BinaryTree::Generator
      expect(a.inspect.size).to eq 11  
    end

    it 'finds element by path' do
      expect(a.find_element('01').class).to be BinaryTree::Node
    end

    it 'finds path by value' do
      expect(a.find_path(6)).to eq '10'
    end

    it 'finds element by value' do
      expect(a[9].class).to be BinaryTree::Node
    end

    it 'appends new element to the tree' do
      expect((a << 15).length).to eq 12 
    end

    it 'returns the deleted leaf element from the tree' do
      expect((a >> 11).class).to be BinaryTree::Node 
      expect(a.inspect.length).to eq 10
    end

    it 'returns the deleted non-leaf element from the tree' do
      expect((a >> 6).class).to be BinaryTree::Node 
      expect(a.inspect.length).to eq 10
    end
  end

  describe 'empty data tests' do
    it 'returns the empty tree' do
      expect(BinaryTree::Generator.new().inspect).to eq []
    end

    it 'find no element by empty path' do
      expect(a.find_element()).to be nil
    end

    it 'finds no path by empty value' do
      expect(a.find_path()).to be nil
    end

    it 'finds no element by empty value' do
      expect(a[]).to be nil
    end

    it 'doesn\`t append new empty element to the tree' do
      expect(a << nil).to be nil
    end

    it 'returns no element if value is empty' do
      expect((a >> nil)).to be nil 
      expect(a.inspect.length).to eq 11
    end
  end

  describe 'incorrect data tests' do
    it 'finds no element by incorrect path' do
      expect(a.find_element('011011')).to be nil
    end

    it 'finds no path by incorrect value' do
      expect(a.find_path(15)).to be nil
    end

    it 'finds no element by incorrect value' do
      expect(a[15]).to be nil
    end

    it 'returns no element if element is not found' do
      expect((a >> 2500)).to be nil
      expect(a.inspect.length).to eq 11
    end
  end

  describe 'incorrect data type tests' do
    it 'finds no element by incorrect path type' do
      expect(a.find_element('a')).to be nil
    end

    it 'finds no path by incorrect value type' do
      expect(a.find_path('a')).to be nil
    end

    it 'returns no element if incorrect type' do
      expect((a >> 'a')).to be nil
      expect(a.inspect.length).to eq 11
    end

    it 'returns the tree without incorrect data types' do
      expect(BinaryTree::Generator.new('a', 2, 4, 'b').inspect.length).to eq 2      
      expect(BinaryTree::Generator.new(5, 2, 4, 'b').inspect.length).to eq 3
    end
  end

  describe 'alias methods tests' do

  end
end

