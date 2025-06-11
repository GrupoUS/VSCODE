import React, { useState, useEffect } from 'react';
import productService from '../services/productService';

const ProductForm = ({ product, onSubmit, onProductCreated }) => {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [countInStock, setCountInStock] = useState('');

  useEffect(() => {
    if (product) {
      setName(product.name);
      setDescription(product.description);
      setPrice(product.price);
      setCountInStock(product.countInStock);
    }
  }, [product]);

  const submitHandler = async (e) => {
    e.preventDefault();
    const productData = { name, description, price, countInStock };

    try {
      if (product) {
        await productService.updateProduct(product._id, productData);
        alert('Product updated successfully!');
      } else {
        const newProduct = await productService.createProduct(productData);
        alert('Product created successfully!');
        if (onProductCreated) {
          onProductCreated(newProduct);
        }
      }
      // Optionally clear form or redirect
    } catch (error) {
      console.error('Operation failed:', error);
      alert(`Operation failed: ${error.message}`);
    }
  };

  return (
    <form onSubmit={submitHandler}>
      <div>
        <label>Name</label>
        <input
          type="text"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
      </div>
      <div>
        <label>Description</label>
        <input
          type="text"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
      </div>
      <div>
        <label>Price</label>
        <input
          type="number"
          value={price}
          onChange={(e) => setPrice(e.target.value)}
        />
      </div>
      <div>
        <label>Count In Stock</label>
        <input
          type="number"
          value={countInStock}
          onChange={(e) => setCountInStock(e.target.value)}
        />
      </div>
      <button type="submit">{product ? 'Update' : 'Create'}</button>
    </form>
  );
};

export default ProductForm;
