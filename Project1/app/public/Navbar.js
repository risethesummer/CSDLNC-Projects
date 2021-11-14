import React, { Fragment } from "react";
import { connect } from "react-redux";
import PropTypes from "prop-types";
import { Link, NavLink } from "react-router-dom";
import { logout } from "../actions/auth";
import Alert from "./Alert";
import * as url from '../assets/image/logo.png'; 
const Navbar = ({ auth: { isAuthenticated, loading }, logout }) => {
    const authLink = (
        <Fragment>
            <a className="navbar__top__auth__link" onClick={logout} href="#!">
                Logout
            </a>
            <Link className="navbar__top__auth__link" to='/profile'>
                Profile
            </Link>
        </Fragment>
    );

    const guestLink = (
        <Fragment>
            <Link to="/login" className="navbar__top__auth__link">
                Log in
            </Link>
            <Link to="/signup" className="navbar__top__auth__link">
                Sign up
            </Link>
        </Fragment>
    );

    return (
        <Fragment>
            <nav className="navbar">
                <div className="navbar__top">
                    <div className="navbar__top__logo">
                        <Link className="navbar__top__logo__link" to="/">
                            <img className="navbar__top__logo__image"  src={url.default} alt='logo'/>
                        </Link>
                    </div>
                    <div className="navbar__top__itemlink">
                        <li className="navbar__top__itemlink__item">
                            <NavLink
                                className="navbar__top__itemlink__item__link"
                                exact
                                to="/"
                            >
                                Home
                            </NavLink>
                        </li>
                        {/* <li className="navbar__top__itemlink__item">
                            <NavLink
                                className="navbar__top__itemlink__item__link"
                                exact
                                to="/about"
                            >
                                About
                            </NavLink>
                        </li> */}
                        {/* <li className="navbar__top__itemlink__item">
                            <NavLink
                                className="navbar__top__itemlink__item__link"
                                exact
                                to="/contact"
                            >
                                Contact
                            </NavLink>
                        </li> */}
                        <li className="navbar__top__itemlink__item">
                            <NavLink
                                className="navbar__top__itemlink__item__link"
                                exact
                                to="/listing"
                            >
                                Listing
                            </NavLink>
                        </li>
                        <li className="navbar__top__itemlink__item">
                            <NavLink
                                className="navbar__top__itemlink__item__link"
                                exact
                                to="/my-listing"
                            >
                                My Listing
                            </NavLink>
                        </li>
                    </div>
                    <div className="navbar__top__auth">
                        {/* if loading equals false then render authlink or guestlink,if loading equals true render nothing */}
                        {!loading && (
                            <Fragment>
                                {isAuthenticated ? authLink : guestLink}
                            </Fragment>
                        )}
                    </div>
                </div>
                {/* <div className='navbar__bottom'>
                    <li className='navbar__bottom__item'>
                        <NavLink className='navbar__bottom__item__link' exact to='/'>Home</NavLink>
                    </li>
                    <li className='navbar__bottom__item'>
                        <NavLink className='navbar__bottom__item__link' exact to='/about'>About</NavLink>
                    </li>
                    <li className='navbar__bottom__item'>
                        <NavLink className='navbar__bottom__item__link' exact to='/contact'>Contact</NavLink>
                    </li>
                    <li className='navbar__bottom__item'>
                        <NavLink className='navbar__bottom__item__link' exact to='/listing'>Listing</NavLink>
                    </li>
                </div> */}
            </nav>
            <Alert />
        </Fragment>
    );
};

const mapStateToProps = (state) => ({
    auth: state.auth,
    logout: () => {},
});

Navbar.propTypes = {
    logout: PropTypes.func.isRequired,
    auth: PropTypes.object.isRequired,
};

export default connect(mapStateToProps, { logout })(Navbar);
