shared_context 'rack_test' do
  def response_should_be_204_no_content
    expect(last_response.status).to eq(204)
  end

  def response_should_be_400_bad_request
    expect(last_response.status).to eq(400)
  end

  def response_should_be_401_unauthorized
    expect(last_response.status).to eq(401)
  end

  def response_should_be_404_not_found
    expect(last_response.status).to eq(404)
  end

  def response_should_be_422_unprocessable_entity
    expect(last_response.status).to eq(422)
  end

  def response_should_be_200_ok
    expect(last_response.status).to eq(200)
  end

  def response_should_be_false
    response_should_be_200_ok
    response_should_be_json
    expect(last_response.body).to be_json_eql('false')
  end

  def response_should_be_json
    expect(last_response.headers['Content-Type']).to match(%r{^application/json})
  end

  def response_should_be_true
    response_should_be_200_ok
    response_should_be_json
    expect(last_response.body).to be_json_eql('true')
  end
end
