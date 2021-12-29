import axios from "axios";
import { useContext, useState } from "react";
import { Modal } from "react-bootstrap";
import { API_URL, userContext } from "../Contexts";
import ProductCard from "./ProductCardInCart";

const OrderCard = ({
	setStatus,
	orderID,
	date,
	products,
	state,
	totalPrice,
	payment,
	setLoading,
	...props
}) => {
	const [modal, setModal] = useState(false);
	const [type, setType] = useState("cash");
	const [formData, setFormData] = useState({});

	const onSubmit = (e) => {
		e.preventDefault();
		setLoading(true);
		axios
			.post(API_URL + `/payment/${type}/${orderID}`, {
				...formData,
			})
			.then((resp) => {
				setModal(false);
				setStatus("paid");
			})
			.catch((err) => {
				setLoading(false);
				setModal(false);
				alert("Errors");
			});
	};

	return (
		<div
			id={orderID}
			className="row p-2 bg-white border rounded"
			{...props}
		>
			<div className="col-md-6 mt-1">
				<h5>Order {orderID}</h5>
				<p className="text-justify text-truncate para mb-0">
					Placed date: {date}
					<br />
					<br />
					Items: {products.length}
					<br />
					State: {state}
				</p>
			</div>
			<div className="align-items-center align-content-center col-md-3 border-left mt-1">
				<h6>Total: {totalPrice} &#8363;</h6>
				<div className="d-flex flex-column mt-4">
					<button
						className="btn btn-outline-primary btn-sm mt-2"
						type="button"
						onClick={() => setModal(true)}
					>
						Detail
					</button>
				</div>
			</div>
			<Modal
				size="lg"
				show={modal}
				onHide={() => setModal(false)}
				aria-labelledby="example-modal-sizes-title-lg"
			>
				<Modal.Header closeButton>
					<Modal.Title id={`modal-${orderID}`}>
						<h5>Order {orderID}</h5>
					</Modal.Title>
				</Modal.Header>
				<Modal.Body>
					<div className="d-flex justify-content-center row">
						<div
							className="col-md-10"
							style={{
								width: "70vw",
								height: "50vh",
								overflowY: "scroll",
							}}
						>
							{products.map((value, idx) => (
								<ProductCard {...value} key={idx} />
							))}
						</div>
						{!payment ? (
							<form className="w-50" onSubmit={onSubmit}>
								<div className="form-outline mb-4">
									<label className="form-label" for="type">
										Payment type
									</label>
									<select
										id="type"
										className="form-control"
										value={type}
										onChange={(e) => {
											if (e.target.value == "cash")
												setFormData({});
											else
												setFormData({
													number: "",
													owner: "",
													bank: "",
												});
											setType(e.target.value);
										}}
										required
									>
										<option>cash</option>
										<option>atm</option>
									</select>
								</div>
								{type == "cash" ? (
									<></>
								) : (
									<>
										<div className="form-outline mb-4">
											<label
												className="form-label"
												for="number"
											>
												Card number
											</label>
											<input
												type="text"
												id="number"
												className="form-control"
												value={formData.number}
												onChange={(e) => {
													setFormData({
														...formData,
														number: e.target.value,
													});
												}}
												required
											/>
										</div>
										<div className="form-outline mb-4">
											<label
												className="form-label"
												for="owner"
											>
												Card owner
											</label>
											<input
												type="text"
												id="owner"
												className="form-control"
												value={formData.owner}
												onChange={(e) => {
													setFormData({
														...formData,
														owner: e.target.value,
													});
												}}
												required
											/>
										</div>
										<div className="form-outline mb-4">
											<label
												className="form-label"
												for="bank"
											>
												Card bank
											</label>
											<input
												type="text"
												id="bank"
												className="form-control"
												value={formData.bank}
												onChange={(e) => {
													setFormData({
														...formData,
														bank: e.target.value,
													});
												}}
												required
											/>
										</div>
									</>
								)}
								<button
									type="submit"
									className="btn btn-primary btn-lg mb-1"
								>
									Submit
								</button>
								<span className="m-2">Total: {totalPrice} &#8363;</span>
							</form>
						) : (
							<h6 className="m-2">Total: {totalPrice} &#8363;</h6>
						)}
					</div>
				</Modal.Body>
			</Modal>
		</div>
	);
};

export default OrderCard;
