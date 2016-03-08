shared_context 'rack_test' do
  def response_should_be_401_unauthorized
    expect(last_response.status).to eq(401)
  end

  def response_should_be_400_bad_request
    expect(last_response.status).to eq(400)
  end
end
