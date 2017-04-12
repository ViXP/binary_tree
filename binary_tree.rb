module BinaryTree
  class Generator
    # Binary tree generator class
    # input (INTEGERS): the elements of tree
    # output (HASH): the hash with human readable nodes
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
      to_s
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
      el
    end

    def << val = nil
      return nil unless val
      @path = []
      search_parent(@tree[0], val, true)
      inspect
    end

    def >> val = nil
      return nil unless val
      path = search_path val
      if path 
        el = search_element(path)
        parent = search_element(path.slice(0, (path.length - 1)))
        if el.status == :leaf
          if parent.left == el
            parent.left = nil
          else
            parent.right = nil
          end
          @tree.delete(el)
          el
        else
          # MUST BE WRITTEN
        end
      else
        nil
      end
    end

    def inspect
      [*@tree.map(&:show)]
    end

    # Methods aliases
    alias_method :find, :search
    alias_method :[], :search
    alias_method :find_path, :search_path
    alias_method :find_element, :search_element
    alias_method :push, :<< 
    alias_method :delete, :>>
    alias_method :show, :inspect
    alias_method :to_s, :inspect

    private

    def position_node value
      search_parent(@tree[0], value, true)
    end

    def search_parent parent, value, build = nil      
      if parent and parent.value <= value
        return parent if !build and parent.value == value  # node found
        @path << 1
        if parent.right == nil and build
          node = Node.new(value)
          @tree << node
          parent.right = node
          parent.right
        else
          search_parent parent.right, value, build
        end
      elsif parent
        @path << 0
        if parent.left == nil and build
          node = Node.new(value)
          @tree << node
          parent.left = node
          parent.left
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
    # input (INTEGER): the value of element
    # output (INTEGER): the value of element
    attr_accessor :left, :right
    attr_reader :value, :status

    @@quantity = 0

    def self.quantify      
      @@quantity = @@quantity + 1
    end

    def initialize val
      @value = val
      left = nil
      right = nil
      @status = :leaf
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

tree = BinaryTree::Generator.new(5,3,2,4,8,7,13,11,9,10,12,15)
p tree