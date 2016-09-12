ActiveAdmin.register User do
  permit_params :role, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :role
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :role, as: :select, collection: User::ROLES
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'User Details' do
      f.input :role, as: :select, collection: User::ROLES, include_blank: false
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      # Leave the password alone if the user left either password field blank
      if permitted_params[:user][:password].blank? ||
          permitted_params[:user][:password_confirmation].blank?
        resource.update_without_password(permitted_params[:user])
      else
        resource.update_attributes(permitted_params[:user])
      end

      if resource.errors.blank?
        redirect_to users_path, notice: 'User updated successfully.'
      else
        render :edit
      end
    end
  end
end
