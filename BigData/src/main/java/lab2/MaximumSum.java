package lab2;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.net.URI;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class MaximumSum {

    private static final Text KEY_JULY = new Text("JULY");
    private static final Text KEY_AUGUST = new Text("AUGUST");
    private static final Text KEY_SEPTEMBER = new Text("SEPTEMBER");

    public static class MaxSum implements Writable {
        private double maxVal;

        public MaxSum() {}

        public MaxSum(final double max) {
            this.maxVal = max;
        }

        public double getMaxVal() {
            return this.maxVal;
        }

        @Override
        public void write(final DataOutput out) throws IOException {
            out.writeDouble(this.maxVal);
        }

        @Override
        public void readFields(final DataInput in) throws IOException {
            this.maxVal = in.readDouble();
        }

        @Override
        public String toString() {
            return String.format("maxVal=%s", maxVal);
        }
    }

    public static class MaxSumMapper extends Mapper<Object, Text, Text, MaxSum> {

        @Override
        public void map(final Object key, final Text value, final Context context) throws IOException, InterruptedException {
            final String csvLine = value.toString();
            final String[] csvField = csvLine.split(",");
            if (csvField[0].contains(".07.")) {
                context.write(KEY_JULY, new MaxSum(Double.parseDouble(csvField[3])));
                context.write(KEY_JULY, new MaxSum(Double.parseDouble(csvField[10])));
                context.write(KEY_JULY, new MaxSum(Double.parseDouble(csvField[17])));
            }
            if (csvField[0].contains(".08.")) {
                context.write(KEY_AUGUST, new MaxSum(Double.parseDouble(csvField[3])));
                context.write(KEY_AUGUST, new MaxSum(Double.parseDouble(csvField[10])));
                context.write(KEY_AUGUST, new MaxSum(Double.parseDouble(csvField[17])));
            }
            if (csvField[0].contains(".09.")) {
                context.write(KEY_SEPTEMBER, new MaxSum(Double.parseDouble(csvField[3])));
                context.write(KEY_SEPTEMBER, new MaxSum(Double.parseDouble(csvField[10])));
                context.write(KEY_SEPTEMBER, new MaxSum(Double.parseDouble(csvField[17])));
            }
        }
    }

    public static class MaxSumReducer extends Reducer<Text, MaxSum, Text, MaxSum> {

        @Override
        public void reduce(Text key, Iterable<MaxSum> values, Context context) throws IOException, InterruptedException {
            double sum = 0;
            for (MaxSum val : values) {
                sum += val.getMaxVal();
            }
            context.write(key, new MaxSum(sum));
        }
    }

    public static void main(String... args) throws Exception {
        final Configuration conf = new Configuration();
        final String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        if (otherArgs.length != 3) {
            System.err.println("Usage: AverageCount <hdfs://> <in> <out>");
            System.exit(2);
        }
        final FileSystem hdfs = FileSystem.get(new URI(args[0]), conf);
        final Path resultFolder = new Path(args[2]);
        if (hdfs.exists(resultFolder)) {
            hdfs.delete(resultFolder, true);
        }
        final Job job = Job.getInstance(conf, "Market Maximum Sum");
        job.setJarByClass(MaximumSum.class);
        job.setMapperClass(MaxSumMapper.class);
        job.setCombinerClass(MaxSumReducer.class);
        job.setReducerClass(MaxSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(MaxSum.class);

        for (int i = 1; i < otherArgs.length - 1; i++) {
            FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
        }
        FileOutputFormat.setOutputPath(job, new Path(otherArgs[(otherArgs.length - 1)]));

        boolean finishState = job.waitForCompletion(true);
        System.out.println("Job Running Time: " + (job.getFinishTime() - job.getStartTime()));

        System.exit(finishState ? 0 : 1);
    }
}
