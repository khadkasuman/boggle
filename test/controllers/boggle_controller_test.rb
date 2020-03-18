require 'test_helper'

class BoggleControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should get random sequence of alphabets" do
    get "boggle/generate"
    assert !@response.sequence.nil?
  end
end
