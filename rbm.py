import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim

# Hyperparameters
num_users = 100       
num_topics = 20       
hidden_units = 50     
epochs = 200          
batch_size = 10       

# Generate synthetic data (User-Topic Matrix)
np.random.seed(0)
user_topic_matrix = np.random.randint(2, size=(num_users, num_topics))  

class RBM(nn.Module):
    def __init__(self, visible_units, hidden_units):
        super(RBM, self).__init__()
        self.W = nn.Parameter(torch.randn(hidden_units, visible_units) * 0.01)  
        self.h_bias = nn.Parameter(torch.zeros(hidden_units))  
        self.v_bias = nn.Parameter(torch.zeros(visible_units)) 

    def sample_hidden(self, v):
        h_prob = torch.sigmoid(torch.nn.functional.linear(v, self.W, self.h_bias))
        return h_prob, torch.bernoulli(h_prob)

    def sample_visible(self, h):
        v_prob = torch.sigmoid(torch.nn.functional.linear(h, self.W.t(), self.v_bias))
        return v_prob, torch.bernoulli(v_prob)

    def forward(self, v):
        h_prob, h_sample = self.sample_hidden(v)
        v_prob, v_sample = self.sample_visible(h_sample)
        return v_prob, v_sample

# Train the RBM
rbm = RBM(num_topics, hidden_units)
train_data = torch.FloatTensor(user_topic_matrix)  

optimizer = optim.Adam(rbm.parameters(), lr=0.01)

for epoch in range(epochs):
    loss_ = []
    for i in range(0, num_users, batch_size):
        v = train_data[i:i+batch_size]
        v_prob, v_sample = rbm(v)  
        v_loss = torch.mean((v - v_prob) ** 2)  
        
        optimizer.zero_grad()
        v_loss.backward()
        optimizer.step()
        
        loss_.append(v_loss.item())
    print(f"Epoch {epoch + 1}: Loss = {np.mean(loss_):.4f}")

# Making Recommendations for a specific user
user_id = 0 
v = train_data[user_id:user_id+1] 
v_prob, _ = rbm(v)

recommended_topics = torch.topk(v_prob, k=5).indices[0]  
print("Recommended topics for user:", recommended_topics.tolist())
