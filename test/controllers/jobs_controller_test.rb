require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job = jobs(:one)

    Job.__elasticsearch__.import force: true
    Job.__elasticsearch__.refresh_index!
  end


  test "should get index" do
    get jobs_url
    assert_response :success
  end

  test "should get search results" do
    get search_jobs_url(q: "mystring")
    assert_response :success
    assert_not_nil assigns(:jobs)
    assert_equal 2, assigns(:jobs).size
  end


  test "should get new" do
    get new_job_url
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post jobs_url, params: { job: { description: @job.description, published_on: @job.published_on, title: @job.title } }
    end

    assert_redirected_to job_url(Job.last)
  end

  test "should show job" do
    get job_url(@job)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_url(@job)
    assert_response :success
  end

  test "should update job" do
    patch job_url(@job), params: { job: { description: @job.description, published_on: @job.published_on, title: @job.title } }
    assert_redirected_to job_url(@job)
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete job_url(@job)
    end

    assert_redirected_to jobs_url
  end
end
