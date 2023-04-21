class FaradayAdapter
  def initialize(file)
    @response = JSON.parse(File.read(
      Rails.root.join("spec/stub_responses/#{file}")
      )
    )
  end

  def get
    self
  end

  def method_missing(method, *args, &block)
    @response[method.to_s]
  end
end