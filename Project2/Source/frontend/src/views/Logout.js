import { useEffect } from "react";

const Logout = ({ setLoading, setUser, setAuthenticated }) => {
	useEffect(() => {
		setLoading(true);
		setUser({});
		setAuthenticated(false);
		setLoading(false);
	}, []);

	return <></>;
};

export default Logout;
