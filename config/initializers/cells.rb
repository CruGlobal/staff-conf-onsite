require Rails.root.join('lib', 'page_cells.rb')
ActiveAdmin::ResourceDSL.include PageCells
