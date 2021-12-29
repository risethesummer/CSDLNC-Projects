import axios from "axios";
import { useContext, useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { API_URL, loginContext } from "../Contexts";

const Signup = ({ setLoading, setUser, setAuthenticated }) => {
	const isAuthenticated = useContext(loginContext);
	const navigate = useNavigate();
	const [formData, setFormData] = useState({
		userName: "",
		password: "",
		name: "",
		address: "",
		phone: "",
		email: "",
		dayOfBirth: new Date(),
	});

	useEffect(() => {
		if (isAuthenticated) navigate("/", { replace: true });
	}, [isAuthenticated]);

	const onSubmit = (e) => {
		e.preventDefault();
		setLoading(true);
		console.log(formData);
		axios
			.post(API_URL + "/user/signup", {
				...formData,
				dayOfBirth: formData["dayOfBirth"].toISOString(),
			})
			.then((resp) => {
				setLoading(false);
				navigate("/login", { replace: true });
			})
			.catch((err) => {
				setLoading(false);
				console.log(err);
				alert("errors!");
			});
	};

	return (
		<div className="container py-5 h-100">
			<div className="row d-flex justify-content-center align-items-center h-100">
				<div className="col-lg-8 col-xl-6">
					<div className="card rounded-3">
						<div className="card-body p-4 p-md-5">
							<h3 className="mb-4 pb-2 pb-md-0 mb-md-5 px-md-2">
								Registration Info
							</h3>

							<form className="px-md-2" onSubmit={onSubmit}>
								<div className="form-outline mb-4">
									<label className="form-label" for="name">
										Name
									</label>
									<input
										type="text"
										id="name"
										className="form-control"
										value={formData.name}
										onChange={(e) => {
											setFormData({
												...formData,
												name: e.target.value,
											});
										}}
										required
									/>
								</div>

								<div classNampue="form-outline mb-4">
									<label
										className="form-label"
										for="password"
									>
										Username
									</label>
									<input
										type="text"
										id="userName"
										className="form-control"
										value={formData.userName}
										onChange={(e) => {
											setFormData({
												...formData,
												userName: e.target.value,
											});
										}}
										required
									/>
								</div>

								<div className="form-outline mb-4">
									<label
										className="form-label"
										for="password"
									>
										Password
									</label>
									<input
										type="password"
										id="password"
										className="form-control"
										value={formData.password}
										onChange={(e) => {
											setFormData({
												...formData,
												password: e.target.value,
											});
										}}
										required
									/>
								</div>
								<div className="form-outline mb-4">
									<label className="form-label" for="address">
										Address
									</label>
									<textarea
										id="address"
										className="form-control"
										value={formData.address}
										onChange={(e) => {
											setFormData({
												...formData,
												address: e.target.value,
											});
										}}
										rows="3"
									/>
								</div>
								<div className="form-outline mb-4">
									<label className="form-label" for="phone">
										Phone
									</label>
									<input
										type="tel"
										id="phone"
										className="form-control"
										value={formData.phone}
										onChange={(e) => {
											setFormData({
												...formData,
												phone: e.target.value,
											});
										}}
									/>
								</div>

								<button
									type="submit"
									className="btn btn-primary btn-lg mb-1"
								>
									Submit
								</button>
								<Link to="/login" className="m-2">
									already have account ?
								</Link>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};

export default Signup;
