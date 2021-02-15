module.exports.add = function (arg0, success, error) {
exec(success, error, 'LocationTrackPlugin', 'add', [arg0]);
};
module.exports.trackLocation = function (arg0, success, error) {
exec(success, error, 'LocationTrackPlugin', 'trackLocation', [arg0]);
}
module.exports.stopTracking = function ( success, error) {
exec(success, error, 'LocationTrackPlugin', 'stopTracking');
}