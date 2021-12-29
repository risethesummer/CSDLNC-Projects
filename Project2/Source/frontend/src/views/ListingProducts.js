import axios from "axios";
import { useEffect, useState } from "react";
import ProductCard from "../components/ProductCard";
import { API_URL } from "../Contexts";

const ListingProducts = ({ setLoading }) => {
	const [data, setData] = useState([]);

	useEffect(() => {
		setLoading(true);
		axios
			.get(API_URL + "/product")
			.then((resp) => {
				setData(resp.data);
				setLoading(false);
			})
			.catch((err) => {
				setLoading(false);
			});
	}, []);

	return (
		<div className="container mt-5 mb-5">
			<div className="d-flex justify-content-center row">
				<div className="col-md-10">
					{data.map((value, idx) => (
						<ProductCard
							{...value}
							key={idx}
							setLoading={setLoading}
						/>
					))}
				</div>
			</div>
		</div>
	);
};

export default ListingProducts;
