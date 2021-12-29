const ProductCard = ({
	id,
	name,
	description,
	price,
	amount,
	stockAmount,
	type,
	...props
}) => {
	return (
		<div id={id} className="row p-2 bg-white border rounded" {...props}>
			<div className="col-md-3 mt-1">
				<img
					className="img-fluid img-responsive rounded product-image"
					src="https://loremflickr.com/320/240?random=1"
				/>
			</div>
			<div className="col-md-6 mt-1">
				<h5>{name}</h5>
				<p className="text-justify text-truncate para mb-0">
					{description}
					<br />
					<br />
				</p>
			</div>
			<div className="align-items-center align-content-center col-md-3 border-left mt-1">
				<div className="d-flex flex-row align-items-center">
					<h4 className="mr-1">{price} &#8363;</h4>
					<span>x {amount}</span>
				</div>
				<h6 className="text-success">
					Total: {amount * price} &#8363;
				</h6>
			</div>
		</div>
	);
};

export default ProductCard;
