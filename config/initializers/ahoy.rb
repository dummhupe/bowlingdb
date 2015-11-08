class Ahoy::Store < Ahoy::Stores::ActiveRecordStore
  def track_event(name, properties, options)
    super do |event|
      event.group = properties[:group]
    end
  end
end
