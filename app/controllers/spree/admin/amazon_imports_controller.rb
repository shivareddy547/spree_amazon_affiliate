class Spree::Admin::AmazonImportsController < Spree::Admin::BaseController

  def create
    if defined? Delayed::Job
      csv = Spree::Amazon::Import.new(:attachment => params[:upload_file])
      csv.save!
      Spree::Amazon::Import.delay.run(csv.attachment.expiring_url(36000), import_id: csv.id)
    else
      Spree::Amazon::Import.run(params[:upload_file].path)
    end
    redirect_to admin_amazon_imports_path, :notice => t(:upload_complete)
  end

  def index
  end

  def new
    send_data File.read(File.expand_path('../../../../assets/templates/Amazon Import Template.csv', __FILE__)), :filename => t(:amazon_import_template) + '.csv'
  end

end
