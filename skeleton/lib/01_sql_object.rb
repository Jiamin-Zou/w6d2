require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
    if @columns
      @columns
    else
      columns = DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          "#{self.table_name}"
      SQL

      @columns = columns.first.map(&:to_sym)
    end
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) { self.attributes[col] }
      define_method("#{col}=") { |arg |self.attributes[col] = arg }
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    if @table_name
      @table_name
    else
      name = self.to_s
      @table_name = name.tableize
    end    
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    # ...
    results.map {|datum| self.new(datum) }
  end

  def self.find(id)
    # ...
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        "#{self.table_name}"
      WHERE
        id = ?
    SQL
    return nil if results.empty?
    self.new(results.first)
  end

  def initialize(params = {})
    # ...
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym
      if self.class.columns.include?(attr_sym)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end

  end

  def attributes
    # ...
    @attributes||={}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
    col_names = self.class.columns.join(',')
    n = col_names.length
    q_marks = (["?"] * n).join(",")

    results = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        "#{self.table_name}"
      WHERE
        id = ?
    SQL

  end

  def update
    # ...
  end

  def save
    # ...
  end
end
