package com.yazino.client.log;

import com.yazino.configuration.YazinoConfiguration;
import com.yazino.platform.event.EventWorkerServersConfiguration;
import com.yazino.platform.messaging.WorkerServers;
import com.yazino.platform.messaging.WorkerServiceFactory;
import com.yazino.platform.messaging.publisher.QueuePublishingService;
import com.yazino.platform.messaging.publisher.SafeQueuePublishingEventService;
import com.yazino.platform.messaging.publisher.SpringAMQPRoutedQueuePublishingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@Import(EventWorkerServersConfiguration.class)
public class ClientLogEventServiceConfiguration {
    private WorkerServiceFactory factory = new WorkerServiceFactory();

    @Autowired(required = true)
    @Qualifier("eventWorkerServers")
    private WorkerServers workerServers;

    @Value("${strata.rabbitmq.event.exchange}")
    private String exchangeName;

    @Autowired
    private YazinoConfiguration yazinoConfiguration;

    @Bean
    public QueuePublishingService<ClientLogEvent> clientLogEventQueuePublishingService(
            @Value("${strata.rabbitmq.event.client-log.queue}") final String queueName,
            @Value("${strata.rabbitmq.event.client-log.routing-key}") final String routingKey) {
        final SpringAMQPRoutedQueuePublishingService publisher = factory.createPublisher(
                workerServers, exchangeName, queueName, routingKey, yazinoConfiguration);
        return new SafeQueuePublishingEventService<ClientLogEvent>(publisher);
    }
}
