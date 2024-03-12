require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
    test 'render a list of products' do
        get products_path

        assert_response :success
        assert_select '.product', 3
        assert_select '.category', 3
    end

    test 'render a list of products filtered by category' do
        get products_path(category_id: categories(:computers).id)

        assert_response :success
        assert_select '.product', 1
        assert_select '.category', 3
    end

    test 'render a list of products filtered by price' do
        get products_path(min_price: 160, max_price: 200)

        assert_response :success
        assert_select '.product', 1
        assert_select 'h2', 'Nintendo switch'
    end

    test 'render a detail productt page' do
        get product_path(products(:ps4))

        assert_response :success
        assert_select '.title', 'PS4'
        assert_select '.description', 'PS4 en buen estado'
        assert_select '.price', '150€'
    end

    test 'render a new product form' do
        get new_product_path

        assert_response :success
        assert_select 'form'
    end

    test 'allow to create a new product' do
        post products_path, params: {
            product: {
                title: 'N64',
                description: 'Le faltan los cables',
                price: 45,
                category_id: categories(:videogames).id
            }
        }
        assert_redirected_to products_path
        assert_equal flash[:notice], 'Producto creado correctamente'
    end
    
    test 'does not allow to create a new product with empty fields' do
        post products_path, params: {
            product: {
                title: '',
                description: 'Le faltan los cables',
                price: 45
            }
        }
        assert_response :unprocessable_entity
    end

    test 'render an edit product form' do
        get edit_product_path(products(:ps4))

        assert_response :success
        assert_select 'form'
    end

    test 'allow to update a new product' do
        patch product_path(products(:ps4)), params: {
            product: {
                price: 50
            }
        }
        assert_redirected_to products_path
        assert_equal flash[:notice], 'Producto actualizado correctamente'
    end
    
    test 'does not allow to update a new product with empty fields' do
        patch product_path(products(:ps4)), params: {
            product: {
                title: ''
            }
        }
        assert_response :unprocessable_entity
    end

    test 'can delete products' do
        assert_difference('Product.count', -1) do
            delete product_path(products(:ps4))
        end

        assert_redirected_to products_path
        assert_equal flash[:notice], 'Producto eliminado correctamente'
    end

end