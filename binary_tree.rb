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
      arr.each_with_index do |el, i| 
        if el.is_a? Numeric
          @tree << Node.new(el)
          (i+1).upto(arr.length - 1) do |j|
            position_node arr[j] if arr[j].is_a? Numeric
          end
          break
        end
      end
      @tree
    end

    def search val = nil
      @path = []
      return nil unless val and val.is_a? Numeric
      search_parent @tree[0], val
    end

    def search_path val = nil
      @path.join if (search val)
    end

    def search_element path = nil
      path = path.to_s.scan(/\d/)
      return nil if path.empty?
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

    def >> val = nil
      return nil unless val
      # MUST BE WRITTEN
    end

    def tree
      [*@tree.map(&:show)]
    end

    # Methods aliases
    alias_method :find, :search
    alias_method :[], :search
    alias_method :find_path, :search_path
    alias_method :find_element, :search_element
    alias_method :push, :<< 
    alias_method :delete, :>>
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
        parent
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

    it 'returns the deleted element from the tree' do
      expect((a >> 11).is_a?).to be Node 
      expect(a.tree.length).to eq 10
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

    it 'doesn\`t append new empty element to the tree' do
      expect(a << nil).to be nil
    end

    it 'returns no element if value is empty' do
      expect((a >> nil)).to be nil 
      expect(a.tree.length).to eq 11
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
      expect(a.tree.length).to eq 11
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
      expect(a.tree.length).to eq 11
    end

    it 'returns the tree without incorrect data types' do
      expect(BinaryTree::Generator.new('a', 2, 4, 'b').tree.length).to eq 2      
      expect(BinaryTree::Generator.new(5, 2, 4, 'b').tree.length).to eq 3
    end
  end

  describe 'alias methods tests' do

  end
end

