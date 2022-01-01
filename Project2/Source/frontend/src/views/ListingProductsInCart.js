import axios from "axios";
import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import ProductCard from "../components/ProductCardInCart";
import { API_URL, userContext } from "../Contexts";

const ListingProductsInCart = ({ setLoading }) => {
	const user = useContext(userContext);
	const navigate = useNavigate();
	const [data, setData] = useState([]);

	useEffect(() => {
		setLoading(true);
		axios
			.get(API_URL + `/cart/${user.id}`)
			.then((resp) => {
				setData(resp.data);
				setLoading(false);
			})
			.catch((err) => {
				setLoading(false);
			});
	}, []);

	const onOrder = (e) => {
		e.preventDefault();
		setLoading(true);
		axios
			.put(API_URL + `/order/${user.id}`, {})
			.then((resp) => {
				setLoading(false);
				navigate("/orders", { replace: true });
			})
			.catch((err) => {
				setLoading(false);
				alert("Errors");
			});
	};

	return (
		<div className="container mt-5 mb-5">
			<div className="d-flex justify-content-center row">
				<div
					className="col-md-10"
					style={{
						width: "70vw",
						height: "70vh",
						overflowY: "scroll",
					}}
				>
					{data.map((value, idx) => (
						<ProductCard
							{...value}
							key={idx}
							setLoading={setLoading}
						/>
					))}
				</div>
				<div className="col-md-10">
					<button
						className="btn btn-primary btn-lg mb-1"
						onClick={onOrder}
					>
						Order
					</button>
					<span className="m-2">
						Total:{" "}
						{data.reduce((p, v) => p + v.amount * v.price, 0)}{" "}
						&#8363;
					</span>
				</div>
			</div>
		</div>
	);
};

export default ListingProductsInCart;
