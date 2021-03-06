Name:			ndppd
Version:	%{?pkg_version}
Release:	1%{?dist}
Summary:	NDP Proxy Daemon

Group:		NetUtils
License:	GPLv3
URL:			https://github.com/sudhagarc/ndppd.git
Source0:	ndppd.tgz
#Source0:	

BuildRequires: systemd
#Requires:	

%description
NDP Proxy Daemon

%prep
%setup -q


%build
make PREFIX=/usr %{?_smp_mflags}


%install
make PREFIX=/usr install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%{_sbindir}/ndppd
%{_unitdir}/ndppd.service
%{_localstatedir}/run/ndppd/

%config
%{_sysconfdir}/ndppd.conf

%doc
%{_mandir}/man1/ndppd.1.gz
%{_mandir}/man5/ndppd.conf.5.gz

%changelog
* Thu Mar 16 2018 Sudhagar Chinnaswamy 	0.2.7
	- Version bump as 0.2.6 was recorded in changelog
	- Fixed issue in daemon mode

* Thu Mar 08 2018 Sudhagar Chinnaswamy 	0.2.5
	- Original source: https://github.com/DanielAdolfsson/ndppd
	- Initial rpm release