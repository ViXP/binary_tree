require 'digest/md5'
require 'rspec'

module BinaryTree
  class Generator
    # Binary tree generator class
    # input: the elements of tree
    # output: the tree of elements
    def initialize *arr
      @tree = []
      @path = []
      @tree << Node.new(arr[0]) if arr.length > 0
      1.upto(arr.length - 1) do |i|
        position_node arr[i]
      end
      @tree
    end

    def search val = nil
      @path = []
      return nil unless val
      search_parent @tree[0], val
    end

    def search_path val = nil
      return nil unless val
      search val
      @path.join
    end

    def search_element path = nil
      return nil unless path
      path = path.to_s.split(/(.)/).reject(&:empty?)
      el = @tree[0]
      path.each do |r|
        if el and r == '1'
          el = el.right
        elsif el
          el = el.left
        else
          return nil
        end
      end
      el.show 
    end

    def << val = nil
      return nil unless val
      @path = []
      search_parent(@tree[0], val, true)
      tree
    end

    def tree
      arr = []  
      @tree.each do |el|
        arr << el.show
      end
      arr
    end

    # Methods aliases
    alias_method :find, :search
    alias_method :[], :search
    alias_method :find_path, :search_path
    alias_method :find_element, :search_element
    alias_method :push, :<< 
    alias_method :show, :tree

    private

    def position_node value
      search_parent(@tree[0], value, true)
    end

    def search_parent parent, value, build = nil
      if parent and parent.value <= value
        return parent.show if !build and parent.value == value  # node found
        @path << 1
        if parent.right == nil and build
          node = Node.new(value)
          @tree << node
          parent.right = node
          parent.right.show
        else
          search_parent parent.right, value, build
        end
      elsif parent
        @path << 0
        if parent.left == nil and build
          node = Node.new(value)
          @tree << node
          parent.left = node
          parent.left.show
        else
          search_parent parent.left, value, build
        end
      else
        @path = []
        parent # returns parent(nil) if not found
      end
    end
  end

  class Node
    # Binary tree node class
    # input: the value of tree
    # output: the value of element
    attr_accessor :left, :right
    attr_reader :value, :status, :id

    @@quantity = 0

    def self.quantify      
      @@quantity = @@quantity + 1
    end

    def initialize val
      @value = val
      left = nil
      right = nil
      @status = :leaf
      @id = Digest::MD5.hexdigest(Node.quantify.to_s)
      id
    end

    def left= left
      @left = left
      update_status
    end

    def right= right
      @right = right
      update_status
    end

    def show
      res = {val: value, status: status }
      res[:left] = left.value if left
      res[:right] = right.value if right
      res
    end

    private

    def update_status
      @status = (left or right) ? :node : :leaf
    end
  end
end

# Several units tests (RSpec library required)
RSpec.describe BinaryTree::Generator do
  let(:a) { BinaryTree::Generator.new(5,8,2,3,6,8,6,9,10,11,4) }

  describe 'correct data tests' do
    it 'is a correct tree' do
      expect(a.class).to eq BinaryTree::Generator
      expect(a.tree.size).to eq 11  
    end

    it 'finds element by path' do
      expect(a.find_element('01')[:val]).to eq 3
    end

    it 'finds path by value' do
      expect(a.find_path(6)).to eq '10'
    end

    it 'finds element by value' do
      expect(a[9][:val]).to eq 9
    end

    it 'appends new element to the tree' do
      expect((a << 15).length).to eq 12 
    end
  end

  describe 'empty data tests' do
    it 'returns the empty tree' do
      expect(BinaryTree::Generator.new().tree).to eq []
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

    it 'doesn`t append new empty element to the tree' do
      expect(a << nil).to eq nil
    end
  end

  describe 'incorrect data tests' do
    it 'finds no element by incorrect path' do
      expect(a.find_element('011011')).to be nil
    end

    it 'finds no path by incorrect value' do
      expect(a.find_path(15)).to be_empty
    end

    it 'finds no element by empty value' do
      expect(a[15]).to be nil
    end
  end

  describe 'incorrect data type tests' do
    it 'returns the empty tree without incorrect data' do
      expect(BinaryTree::Generator.new('a', 2, 4, 'bb').tree).to be_nil
    end
  end
end

