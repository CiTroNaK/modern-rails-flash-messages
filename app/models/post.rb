# frozen_string_literal: true

class Post < ApplicationRecord
  UNDO_TIMEOUT = 8
  include SoftDelete
end
