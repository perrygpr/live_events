module TableDefinitionHelpers
  def guid(*args)
    options = args.extract_options!

    column(args.first, 'char(32)', options)
  end
end

class ActiveRecord::ConnectionAdapters::TableDefinition
  include TableDefinitionHelpers
end

class ActiveRecord::ConnectionAdapters::Table
  include TableDefinitionHelpers
end
