require 'test_helper'
require 'pry'

class CustomHostTest < ActiveSupport::TestCase

  def bust_ghosts
    CustomHost.bust_ghosts
  end

  def activate_some_hosts
    # should activate the following hosts: [["hostname0", "127.0.0.0"], ["hostname1", "127.0.0.1"], ["hostname2", "127.0.0.2"], ["hostname0", "127.0.0.3"]]
    bust_ghosts
    hosts = custom_hosts(:host0, :host1, :host2, :host3)
    hosts.each(&:activate!)
  end

  test "new custom host saves with valid attrs" do
    test_object = CustomHost.new(hostname: "foobar.com", ip_address: "127.0.0.1", description: "Your daily dose of testing")
    assert test_object.valid?
  end

  test "new custom host puts error on object w missing attrs" do
    missing_desc = CustomHost.new(hostname: "foobar.com", ip_address: "127.0.0.1")
    assert_not missing_desc.valid?
    assert missing_desc.errors[:ip_address]
  end

  test "#save validates ip address" do
    bad_ip = CustomHost.create(hostname: 'good hostname', ip_address: "not an ip address", description: "good description")
    assert_not bad_ip.valid?
    assert bad_ip.errors[:ip_address] == ["is invalid"] && bad_ip.errors.count == 1
  end

  test "#parse_ghost_list returns an array of host-ip pairs" do
    activate_some_hosts
    result = CustomHost.parse_ghost_list
    exp = [["hostname0", "127.0.0.0"], ["hostname1", "127.0.0.1"], ["hostname2", "127.0.0.2"], ["hostname0", "127.0.0.3"]]
    assert_equal(exp, result)
    bust_ghosts
  end

  test "#parse_ghost_list returns an empty array for no ghosts" do
    bust_ghosts
    exp = []
    result = CustomHost.parse_ghost_list
    assert_equal exp, result
  end

  test "#activate! adds a ghost to /etc/hosts" do
    bust_ghosts
    test = custom_hosts(:host0)
    test.activate!
    assert_equal [["hostname0","127.0.0.0"]], CustomHost.parse_ghost_list
  end

  test "#activate! won't change @active status if add_ghost fails" do
    test = custom_hosts(:host1)
    test.stub :add_ghost, false do
      test.activate!
    end
    refute test.active
  end

  test "#deactivate! removes a ghost from /etc/hosts" do
    activate_some_hosts
    test = custom_hosts(:host2)
    test.deactivate!
    assert_equal [["hostname0", "127.0.0.0"], ["hostname1", "127.0.0.1"], ["hostname0", "127.0.0.3"]], CustomHost.parse_ghost_list

  end

  test "#deactivate! won't change @active status if delete_ghost fails" do
    activate_some_hosts
    test = custom_hosts(:host2)
    assert test.active
    test.stub :delete_ghost, false do
      test.activate!
    end
    assert test.active
  end

  test "#deactivate! doesn't remove other ghosts with the same hostname" do
    # skip "the ghost cli doesn't currently support selective removal- need to implement workaround"
    activate_some_hosts
    test = custom_hosts(:host3)
    test.deactivate!
    assert_equal [["hostname0", "127.0.0.0"], ["hostname1", "127.0.0.1"], ["hostname2", "127.0.0.2"]], CustomHost.parse_ghost_list

  end



  # to hypothetically allow the ghost gem to operate independently of load test server
  test "ghosts are isolated in /etc/hosts within a 'loadTestServer' section" do
    skip "Not implemented"
  end

  def teardown
    # this should prob be a helper method
    bust_ghosts
  end

end
