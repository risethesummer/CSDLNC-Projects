import axios from "axios";
import { useContext } from "react";
import { API_URL, userContext } from "../Contexts";

const ProductCard = ({
	id,
	name,
	description,
	stockAmount,
	price,
	setLoading,
	...props
}) => {
	const user = useContext(userContext);
	const addToCart = (e) => {
		e.preventDefault();
		setLoading(true);
		axios.put(
			API_URL + `/cart/${user.id}`, {
				"productID": id,
				"amount": 1
			}
		).then(resp => {
			setLoading(false);
			alert("Added to cart !!")
		}).catch(err => {
			setLoading(false);
			alert("Errors")
		})
	}

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
				</div>
				<div className="d-flex flex-column mt-4">
					{stockAmount < 0 ? (
						<></>
					) : (
						<button
							className="btn btn-outline-primary btn-sm mt-2"
							type="button"
							onClick={addToCart}
						>
							add to cart
						</button>
					)}
				</div>
			</div>
		</div>
	);
};

export default ProductCard;
