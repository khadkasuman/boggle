require 'test_helper'

class BoggleControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "response should not be nil" do
    get "/boggle/generate"
    assert_not_nil @response
  end

  test "should get 4x4 array of alphabets" do
    get "/boggle/generate"
    response = JSON.parse(@response.body)
    assert response["sequence"].size.equal?(4) && response["sequence"][0].size.equal?(4)
  end

  test "should get expected word in given sequence" do
    test_sequence = "patterntriedvhsa"
    words_in_sequence = %w(pattern paris attend vhs)
    get "/boggle/generate?sequence=#{test_sequence}"
    response = JSON.parse(@response.body)
    assert response["words"] & words_in_sequence === words_in_sequence
  end
end
