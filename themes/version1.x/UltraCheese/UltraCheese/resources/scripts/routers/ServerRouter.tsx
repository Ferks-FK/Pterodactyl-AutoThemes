import TransferListener from '@/components/server/TransferListener';
import React, { useEffect, useState } from 'react';
import { NavLink, Route, RouteComponentProps, Switch } from 'react-router-dom';
import NavigationBar from '@/components/NavigationBar';
import ServerConsole from '@/components/server/ServerConsole';
import TransitionRouter from '@/TransitionRouter';
import WebsocketHandler from '@/components/server/WebsocketHandler';
import { ServerContext } from '@/state/server';
import DatabasesContainer from '@/components/server/databases/DatabasesContainer';
import FileManagerContainer from '@/components/server/files/FileManagerContainer';
import { CSSTransition } from 'react-transition-group';
import SuspenseSpinner from '@/components/elements/SuspenseSpinner';
import FileEditContainer from '@/components/server/files/FileEditContainer';
import SettingsContainer from '@/components/server/settings/SettingsContainer';
import ScheduleContainer from '@/components/server/schedules/ScheduleContainer';
import ScheduleEditContainer from '@/components/server/schedules/ScheduleEditContainer';
import UsersContainer from '@/components/server/users/UsersContainer';
import Can from '@/components/elements/Can';
import BackupContainer from '@/components/server/backups/BackupContainer';
import Spinner from '@/components/elements/Spinner';
import ScreenBlock, { NotFound, ServerError } from '@/components/elements/ScreenBlock';
import { httpErrorToHuman } from '@/api/http';
import { useStoreState } from 'easy-peasy';
import SubNavigation from '@/components/elements/SubNavigation';
import NetworkContainer from '@/components/server/network/NetworkContainer';
import InstallListener from '@/components/server/InstallListener';
import StartupContainer from '@/components/server/startup/StartupContainer';
import ErrorBoundary from '@/components/elements/ErrorBoundary';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faExternalLinkAlt } from '@fortawesome/free-solid-svg-icons';
import RequireServerPermission from '@/hoc/RequireServerPermission';
import ServerInstallSvg from '@/assets/images/server_installing.svg';
import ServerRestoreSvg from '@/assets/images/server_restore.svg';
import ServerErrorSvg from '@/assets/images/server_error.svg';
import tw from 'twin.macro';
import { faLayerGroup, faSignOutAlt, faUserCircle } from '@fortawesome/free-solid-svg-icons';
import { faTerminal, faFile, faDatabase, faCalendarAlt, faUsers, faArchive, faNetworkWired, faPlay, faCogs } from '@fortawesome/free-solid-svg-icons';
import styled from 'styled-components/macro';

const ConflictStateRenderer = () => {
    const status = ServerContext.useStoreState(state => state.server.data?.status || null);
    const isTransferring = ServerContext.useStoreState(state => state.server.data?.isTransferring || false);

    return (
        status === 'installing' || status === 'install_failed' ?
            <ScreenBlock
                title={'Running Installer'}
                image={ServerInstallSvg}
                message={'Your server should be ready soon, please try again in a few minutes.'}
            />
            :
            status === 'suspended' ?
                <ScreenBlock
                    title={'Server Suspended'}
                    image={ServerErrorSvg}
                    message={'This server is suspended and cannot be accessed.'}
                />
                :
                <ScreenBlock
                    title={isTransferring ? 'Transferring' : 'Restoring from Backup'}
                    image={ServerRestoreSvg}
                    message={isTransferring ? 'Your server is being transfered to a new node, please check back later.' : 'Your server is currently being restored from a backup, please check back in a few minutes.'}
                />
    );
};

const Navigation = styled.div`
    ${tw`h-16 md:h-full flex-none bg-gradient-to-b from-yellow-400 to-yellow-500 w-full md:w-16 lg:w-20 flex flex-col justify-between pb-6 lg:pb-0`};

    a {
        ${tw`no-underline text-neutral-900 text-2xl py-6 mx-auto cursor-pointer transition-all duration-150 text-center h-12 md:h-16 lg:h-20`};
    }


`;

const Navigationx = styled.div`
    ${tw`h-16 md:h-full flex-none bg-white md:shadow-xl w-full md:w-16 lg:w-20 flex flex-col justify-between pb-6 lg:pb-0`};

    a {
        ${tw`no-underline text-neutral-100 text-xl md:text-2xl py-6 mx-auto cursor-pointer transition-all duration-150 text-center h-12 md:h-16 lg:h-20`};
    }


`;

const ServerRouter = ({ match, location }: RouteComponentProps<{ id: string }>) => {
    const rootAdmin = useStoreState(state => state.user.data!.rootAdmin);
    const [ error, setError ] = useState('');

    const id = ServerContext.useStoreState(state => state.server.data?.id);
    const uuid = ServerContext.useStoreState(state => state.server.data?.uuid);
    const inConflictState = ServerContext.useStoreState(state => state.server.inConflictState);
    const serverId = ServerContext.useStoreState(state => state.server.data?.internalId);
    const getServer = ServerContext.useStoreActions(actions => actions.server.getServer);
    const clearServerState = ServerContext.useStoreActions(actions => actions.clearServerState);

    useEffect(() => () => {
        clearServerState();
    }, []);

    useEffect(() => {
        setError('');

        getServer(match.params.id)
            .catch(error => {
                console.error(error);
                setError(httpErrorToHuman(error));
            });

        return () => {
            clearServerState();
        };
    }, [ match.params.id ]);

    return (
        <React.Fragment key={'server-router'}>
        <div css={tw`flex h-full min-h-screen flex-col md:flex-row`}>
          <aside css={tw`md:h-screen h-32 sticky bottom-0 md:top-0 flex flex-col md:flex-row`}>
          <Navigation>
            <div css={tw`flex flex-row md:flex-col`}>
              <NavLink to={'/'} exact>
                  <FontAwesomeIcon icon={faLayerGroup}/>
              </NavLink>
              <NavLink to={'/account'}>
                  <FontAwesomeIcon icon={faUserCircle}/>
              </NavLink>
            </div>
            <a href={'/auth/logout'}>
                <FontAwesomeIcon icon={faSignOutAlt}/>
            </a>
          </Navigation>
          <Navigationx>
            <div css={tw`flex flex-row md:flex-col`}>
              <NavLink to={`${match.url}`} exact>
                  <FontAwesomeIcon icon={faTerminal}/>
              </NavLink>
              <Can action={'file.*'}>
                <NavLink to={`${match.url}/files`}>
                    <FontAwesomeIcon icon={faFile}/>
                </NavLink>
              </Can>
              <Can action={'schedule.*'}>
                  <NavLink to={`${match.url}/schedules`}><FontAwesomeIcon icon={faCalendarAlt}/></NavLink>
              </Can>
              <Can action={'user.*'}>
                  <NavLink to={`${match.url}/users`}><FontAwesomeIcon icon={faUsers}/></NavLink>
              </Can>
              <Can action={'backup.*'}>
                  <NavLink to={`${match.url}/backups`}><FontAwesomeIcon icon={faArchive}/></NavLink>
              </Can>
              <Can action={'allocation.*'}>
                  <NavLink to={`${match.url}/network`}><FontAwesomeIcon icon={faNetworkWired}/></NavLink>
              </Can>
              <Can action={'database.*'}>
                  <NavLink to={`${match.url}/database`}><FontAwesomeIcon icon={faDatabase}/></NavLink>
              </Can>
              <Can action={'startup.*'}>
                  <NavLink to={`${match.url}/startup`}><FontAwesomeIcon icon={faPlay}/></NavLink>
              </Can>
              <Can action={[ 'settings.*', 'file.sftp' ]} matchAny>
                  <NavLink to={`${match.url}/settings`}><FontAwesomeIcon icon={faCogs}/></NavLink>
              </Can>
            </div>
          </Navigationx>
          </aside>
          <main css={tw`flex-grow`}>
            <NavigationBar/>
            {(!uuid || !id) ?
                error ?
                    <ServerError message={error}/>
                    :
                    <Spinner size={'large'} centered/>
                :
                <>
                    <InstallListener/>
                    <TransferListener/>
                    <WebsocketHandler/>
                    {(inConflictState && (!rootAdmin || (rootAdmin && !location.pathname.endsWith(`/server/${id}`)))) ?
                        <ConflictStateRenderer/>
                        :
                        <ErrorBoundary>
                            <TransitionRouter>
                                <Switch location={location}>
                                    <Route path={`${match.path}`} component={ServerConsole} exact/>
                                    <Route path={`${match.path}/files`} exact>
                                        <RequireServerPermission permissions={'file.*'}>
                                            <FileManagerContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/files/:action(edit|new)`} exact>
                                        <SuspenseSpinner>
                                            <FileEditContainer/>
                                        </SuspenseSpinner>
                                    </Route>
                                    <Route path={`${match.path}/databases`} exact>
                                        <RequireServerPermission permissions={'database.*'}>
                                            <DatabasesContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/schedules`} exact>
                                        <RequireServerPermission permissions={'schedule.*'}>
                                            <ScheduleContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/schedules/:id`} exact>
                                        <ScheduleEditContainer/>
                                    </Route>
                                    <Route path={`${match.path}/users`} exact>
                                        <RequireServerPermission permissions={'user.*'}>
                                            <UsersContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/backups`} exact>
                                        <RequireServerPermission permissions={'backup.*'}>
                                            <BackupContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/network`} exact>
                                        <RequireServerPermission permissions={'allocation.*'}>
                                            <NetworkContainer/>
                                        </RequireServerPermission>
                                    </Route>
                                    <Route path={`${match.path}/startup`} component={StartupContainer} exact/>
                                    <Route path={`${match.path}/settings`} component={SettingsContainer} exact/>
                                    <Route path={'*'} component={NotFound}/>
                                </Switch>
                            </TransitionRouter>
                        </ErrorBoundary>
                    }
                </>
            }
            </main>
            </div>
        </React.Fragment>
    );
};

export default (props: RouteComponentProps<any>) => (
    <ServerContext.Provider>
        <ServerRouter {...props}/>
    </ServerContext.Provider>
);
