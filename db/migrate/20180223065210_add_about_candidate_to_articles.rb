class AddAboutCandidateToArticles < ActiveRecord::Migration[5.1]
  def change
  	add_column :articles, :about_candidate, :text
  end
end
