# Trisul Remote Protocol TRP Demo script
#
# Same as toppers.rb but uses ZMQ transport 
#
# Prints topper for the particular counter group for any  meter in specified time range
# 
#  ruby topper_zmq.rb 192.168.1.45 12001 {C51B48D4-7876-479E-B0D9-BD9EFF03CE2E}
#
require 'trisulrp'

# Check arguments
raise %q{


  topper_zmq.rb - Retrieve toppers for any counter and stat

  Usage   : topper.rb  trisul-zmq-endpt cgguid meter-id
  Example : ruby topper.rb tcp://192.168.1.8:5555 {C51B48D4-7876-479E-B0D9-BD9EFF03CE2E} 0

  The example retrieves toppers for Apps (guid {C51..}) and meter 0 (total bytes)

} unless ARGV.length==3

# parameters 
zmq_endpt   = ARGV.shift
target_guid  = ARGV.shift
target_meter = ARGV.shift

# get topper bucket size - multiply metric by that 
#req = mk_request(TRP::Message::Command::COUNTER_GROUP_INFO_REQUEST,
#				 :counter_group => target_guid )
#resp = TrisulRP::Protocol.get_response_zmq(zmq_endpt,req)
#target_bucket_size = resp.group_details[0].topper_bucket_size
#print "bucket size = #{target_bucket_size}"


# toppers 
    req =TrisulRP::Protocol.mk_request(TRP::Message::Command::COUNTER_GROUP_REQUEST,
         :counter_group => target_guid,
         :meter => target_meter.to_i,
         :time_interval =>  mk_time_interval([Time.at(0),Time.at(9999999999)]))

    TrisulRP::Protocol.get_response_zmq(zmq_endpt,req) do |resp|
          print "Counter Group = #{resp.counter_group}\n"
          print "Meter = #{resp.meter}\n"
          resp.keys.each do |key|
              total_bytes = key.metric * 300
              print "Key = #{key.key} Label = #{key.label}  Metric= #{total_bytes}\n"
          end
    end
