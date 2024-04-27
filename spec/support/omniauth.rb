# frozen_string_literal: true

OmniAuth.config.test_mode = true

OmniAuth.config.add_mock(:github, {
  uid: '12345',
  nickname: 'GitHub',
  email: 'user@github.local'
})
