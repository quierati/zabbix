#!/usr/bin/python2.7
#
#Suporte a Regiao 
#Suporte a 2 parametros dimension
#by: Julio Quierati <julio.quierati> at <gmail.com>

from boto.regioninfo import RegionInfo
from boto import connect_cloudwatch

from optparse import OptionParser
import datetime
import os, time, sys

os.environ['TZ'] = 'UTC'
time.tzset()


parser = OptionParser(usage='%prog [-h] [--help]', version='%prog 0.1')
parser.add_option('-r', '--region', dest='region',
                  default='SP', help='Cloudwatch Dimension')
parser.add_option('-d', '--dimension', dest='dimension',
                  default=None, help='Cloudwatch Dimension')
parser.add_option('-n', '--namespace', dest='namespace',
                  default='AWS/EC2', help='Cloudwatch Namespace')
parser.add_option('-m', '--metric', dest='metric',
                  default='NetworkOut', help='Cloudwatch Metric')
parser.add_option('-s', '--statistic', dest='statistic', type='choice',
                  choices=['Average', 'Sum', 'SampleCount', 'Maximum', 'Minimum'],
                  default='Sum', help='Cloudwatch Statistic')
parser.add_option('-a', '--account', dest='account', type='choice',
                  choices=['labunix',''],
                  default='labunix', help='Account')
parser.add_option('-i', '--interval', dest='interval',
                  default="60", help='Interval')
(options, args) = parser.parse_args()

if len(args) > 0:
    parser.error('Numero errado de argumentos')

if options.interval == "":
        options.interval="60"

interval=int(options.interval)

offset=interval+15

end_time = datetime.datetime.now()
end_time = end_time - datetime.timedelta(seconds=offset)
start_time = end_time - datetime.timedelta(seconds=interval)

if options.region == 'SP':
    region = RegionInfo(name='sa-east-1', endpoint='monitoring.sa-east-1.amazonaws.com')
else:
    region = RegionInfo(name='us-east-1', endpoint='monitoring.us-east-1.amazonaws.com')

if options.account == 'labunix':
        aws_key = 'AKKKKKKKKKKKK'
        aws_secret = '*******************'
elif options.account == '':
        aws_key = ''
        aws_secret = ''


cloudwatch = connect_cloudwatch(region=region,aws_access_key_id=aws_key,aws_secret_access_key=aws_secret,is_secure=True)

if options.dimension:
    dimension = {}
    dimensions = options.dimension.split('=')
    if len(dimensions) == 2:
        dimension[dimensions[0]] = dimensions[1]
    elif len(dimensions) == 4:
        dimension = {dimensions[0]: dimensions[1], dimensions[2]: dimensions[3]}
    
    cloudwatch_result = cloudwatch.get_metric_statistics(interval, start_time, end_time, options.metric, options.namespace, options.statistic, dimension)[0]
else:
        cloudwatch_result = cloudwatch.get_metric_statistics(interval, start_time, end_time, options.metric, options.namespace, options.statistic)[0]


if options.statistic == 'Sum':
    if options.metric in ['NetworkOut', 'NetworkIn']:
        cloudwatch_result = int((cloudwatch_result[options.statistic] * 8 )/interval)
    else:
        cloudwatch_result = int(cloudwatch_result[options.statistic])
else:
    cloudwatch_result = float(cloudwatch_result[options.statistic])


print cloudwatch_result

