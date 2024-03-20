class ProductsController < ApplicationController
    skip_before_action :protect_pages, only: [:index, :show]

    def index
        @categories = Category.order(name: :asc)
        @pagy, @products = pagy_countless(FindProducts.new.call(product_params_index), items: 12)
    end

    def show
        product
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)

        if @product.save
            redirect_to products_path, notice: t('.created')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        product
    end

    def update
        if product.update(product_params)
            redirect_to products_path, notice: t('.updated')
        else
            render :edit, status: :unprocessable_entity
        end

    end

    def destroy
        product.destroy
        redirect_to products_path, notice: t('.destroyed'), status: :see_other

    end

    private

    def product_params
        params.require(:product).permit(:title, :description, :price, :category_id, :photo)
    end

    def product_params_index
        params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page)
    end

    def product
        @product = Product.find(params[:id])
    end
end