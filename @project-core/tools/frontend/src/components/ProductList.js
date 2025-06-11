import React, { useEffect, useState } from 'react';
import productService from '../services/productService';
import ProductCard from './ProductCard'; // Import ProductCard

const ProductList = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchProducts = async () => {
    try {
      const data = await productService.getProducts();
      setProducts(data);
    } catch (err) {
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  const deleteHandler = async (id) => {
    if (window.confirm('Are you sure?')) {
      try {
        await productService.deleteProduct(id);
        fetchProducts(); // Refresh the list after deletion
      } catch (error) {
        console.error('Error deleting product:', error);
        setError(error);
      }
    }
  };

  if (loading) {
    return <div>Loading products...</div>;
  }

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <div>
      <h1>Products</h1>
      {products.length === 0 ? (
        <p>No products found.</p>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(250px, 1fr))', gap: '20px' }}>
          {products.map((product) => (
            <div key={product._id}>
              <ProductCard product={product} />
              {localStorage.getItem('user') && ( // Render delete button only if user is logged in
                <button onClick={() => deleteHandler(product._id)}>Delete</button>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default ProductList;
