require Rails.root.join('lib', 'page_cells.rb')

ActiveAdmin::PageDSL.include PageCells
ActiveAdmin::ResourceDSL.include PageCells
