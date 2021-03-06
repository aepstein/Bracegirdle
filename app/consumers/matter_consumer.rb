class MatterConsumer < Consumer
  def call
    # Determine if the matter already exists
    unless matter = Matter.find_by(application: payload[:object])
      # Create the matter
      matter = Matter.create(
        application: payload[:object]
      )
    end

    # Trigger the status change consumer
    StatusChangeConsumer.new({ object: matter }).call
  end
end
