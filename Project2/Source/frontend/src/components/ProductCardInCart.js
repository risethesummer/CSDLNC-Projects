import axios from "axios";
import { useContext, useState } from "react";
import { API_URL, userContext } from "../Contexts";

const ProductCard = ({
	id,
	name,
	description,
	price,
	amount: initAmount,
	stockAmount,
	type,
	image,
	setLoading,
	...props
}) => {
	const [amount, setAmount] = useState(initAmount);
	const user = useContext(userContext);

	const addAmount = () => {
		setLoading(true);
		axios
			.put(API_URL + `/cart/${user.id}`, {
				productID: id,
				amount: 1,
			})
			.then((resp) => {
				setAmount(amount + 1);
				setLoading(false);
			})
			.catch((err) => {
				setLoading(false);
				alert("Errors");
			});
	};

	const subAmount = () => {
		setLoading(true);
		axios
			.put(API_URL + `/cart/${user.id}`, {
				productID: id,
				amount: -1,
			})
			.then((resp) => {
				setAmount(amount - 1);
				setLoading(false);
			})
			.catch((err) => {
				setLoading(false);
				alert("Errors");
			});
	};

	return (
		<div id={id} className="row p-2 bg-white border rounded" {...props}>
			<div className="col-md-3 mt-1">
				<img
					className="img-fluid img-responsive rounded product-image"
					src={`data:${image.contentType};base64,${image.content}`}
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
				<button
					className="btn btn-outline-primary btn-sm mt-2"
					type="button"
					onClick={addAmount}
				>
					increase
				</button>
				{amount > 1 ? (
					<button
						className="btn btn-outline-danger btn-sm mt-2"
						type="button"
						onClick={subAmount}
					>
						decrease
					</button>
				) : (
					<></>
				)}
			</div>
		</div>
	);
};

export default ProductCard;
