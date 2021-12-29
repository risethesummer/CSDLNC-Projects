import axios from "axios";
import { useContext, useEffect, useState } from "react";
import { Button } from "react-bootstrap";
import OrderCard from "../components/OrderCard";
import { API_URL, userContext } from "../Contexts";

const ListingOrders = ({ setLoading }) => {
	const user = useContext(userContext);
	const [data, setData] = useState([]);
	const [status, setStatus] = useState("processing");

	useEffect(() => {
		setLoading(true);
		axios
			.get(API_URL + `/order/${status}/${user.id}`)
			.then((resp) => {
				setData(resp.data);
				setLoading(false);
			})
			.catch((err) => {
				setLoading(false);
			});
	}, [status]);

	return (
		<div className="container mt-5 mb-5">
			<div className="d-flex justify-content-center row">
				<div className="d-flex mb-4">
					<Button
						variant={
							status == "processing" ? "primary" : "secondary"
						}
						size="sm"
						onClick={() => setStatus("processing")}
					>
						Processing
					</Button>{" "}
					<Button
						variant={status == "paid" ? "primary" : "secondary"}
						size="sm"
						onClick={() => setStatus("paid")}
					>
						Paid
					</Button>{" "}
				</div>
				{data.map((order, idx) => (
					<OrderCard
						{...order}
						setStatus={setStatus}
						setLoading={setLoading}
						key={idx}
					/>
				))}
			</div>
		</div>
	);
};

export default ListingOrders;
