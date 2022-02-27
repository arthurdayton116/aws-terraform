import org.jenkins.plugins.statistics.gatherer.StatisticsConfiguration;
import jenkins.model.*;
String baseUrl = "http://logstash.yourcompany.com";
StatisticsConfiguration descriptor = Jenkins.getInstance()
    .getDescriptorByType(StatisticsConfiguration.class);
descriptor.setQueueUrl("${baseUrl}/jenkins-queue/");
descriptor.setBuildUrl("${baseUrl}/jenkins-build/");
descriptor.setProjectUrl("${baseUrl}/jenkins-project/");
descriptor.setBuildStepUrl("${baseUrl}/jenkins-step/");
descriptor.setScmCheckoutUrl("${baseUrl}/jenkins-scm/");
descriptor.setQueueInfo(Boolean.TRUE);
descriptor.setBuildInfo(Boolean.TRUE);
descriptor.setProjectInfo(Boolean.TRUE);
descriptor.setBuildStepInfo(Boolean.TRUE);
descriptor.setScmCheckoutInfo(Boolean.TRUE);
descriptor.setShouldSendApiHttpRequests(Boolean.TRUE);