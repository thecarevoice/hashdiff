# 
# This module provides methods to diff two hash, patch and unpatch hash
#
module HashDiff

  # Apply patch to object
  #
  # @param [Hash, Array] obj the object to be patchted, can be an Array of a Hash
  # @param [Array] changes e.g. [[ '+', 'a.b', '45' ], [ '-', 'a.c', '5' ], [ '~', 'a.x', '45', '63']]
  # @param [String] delimiter Property-string delimiter
  #
  # @return the object after patch
  #
  # @since 0.0.1
  def self.patch!(obj, changes, delimiter='.')
    changes.each do |change|
      parts = decode_property_path(change[1], delimiter)
      last_part = parts.last

      parent_node = node(obj, parts[0, parts.size-1])

      if change[0] == '+'
        if last_part.is_a?(Fixnum)
          parent_node.insert(last_part, change[2])
        else
          parent_node[last_part] = change[2]
        end
      elsif change[0] == '-'
        if last_part.is_a?(Fixnum)
          parent_node.delete_at(last_part)
        else
          parent_node.delete(last_part)
        end
      elsif change[0] == '~'
        parent_node[last_part] = change[3]
      end
    end

    obj
  end

  # Unpatch an object
  #
  # @param [Hash, Array] obj the object to be unpatchted, can be an Array of a Hash
  # @param [Array] changes e.g. [[ '+', 'a.b', '45' ], [ '-', 'a.c', '5' ], [ '~', 'a.x', '45', '63']]
  # @param [String] delimiter Property-string delimiter
  #
  # @return the object after unpatch
  #
  # @since 0.0.1
  def self.unpatch!(obj, changes, delimiter='.')
    changes.reverse_each do |change|
      parts = decode_property_path(change[1], delimiter)
      last_part = parts.last

      parent_node = node(obj, parts[0, parts.size-1])

      if change[0] == '+'
        if last_part.is_a?(Fixnum)
          parent_node.delete_at(last_part)
        else
          parent_node.delete(last_part)
        end
      elsif change[0] == '-'
        if last_part.is_a?(Fixnum)
          parent_node.insert(last_part, change[2])
        else
          parent_node[last_part] = change[2]
        end
      elsif change[0] == '~'
        parent_node[last_part] = change[2]
      end
    end

    obj
  end

end