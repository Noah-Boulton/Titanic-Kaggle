import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import train_test_split

data = pd.read_csv('titanic/titanic_train_mean_of_groups.csv')
# data.drop(data.columns[0], axis=1)
data = data.drop(['PassengerId', 'Name', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked'], axis=1)
data['Sex'] = np.where(data['Sex'] == 'male', 0, 1) 
# Remove when Si sends new file
# avg = data['Age'].mean()
# data['Age'] = np.where(np.isnan(data['Age']), avg, data['Age'])
print(data.head())
X = data.iloc[:,1:].values
# get the first column of the data
y = data.iloc[:,0:1].values
print(X.shape, y.shape)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

clf = LogisticRegression(random_state=0, solver='lbfgs', multi_class='auto', max_iter = 300).fit(X_train, y_train.ravel())
print(clf.score(X_train, y_train))
print(clf.score(X_test, y_test))
# clf = LogisticRegression(random_state=0, solver='lbfgs', multi_class='auto', max_iter = 300).fit(X, y.ravel())

from sklearn.svm import SVC
svm = SVC(C=1.0, cache_size=200, class_weight=None, coef0=0.0,
    decision_function_shape='ovr', degree=3, gamma='auto', kernel='rbf',
    max_iter=-1, probability=False, random_state=None, shrinking=True,
    tol=0.001, verbose=False)
svm.fit(X_train, y_train.ravel()) 
print(svm.score(X_train, y_train))
print(svm.score(X_test, y_test))



testingData = pd.read_csv('titanic/titanic_test_mean_of_groups.csv')
# testingData.drop(data.columns[0], axis=1)
pID = testingData.iloc[:,0:1].values
testingData = testingData.drop(['PassengerId', 'Name', 'SibSp', 'Parch', 'Ticket', 'Fare', 'Cabin', 'Embarked'], axis=1)
testingData['Sex'] = np.where(testingData['Sex'] == 'male', 0, 1) 

print(testingData.head())
labels = svm.predict(testingData)
output = []
for i in range(0, len(pID)):
    output.append([pID[i][0],labels[i]])
header = ['PassengerId', 'Survived']
header = ','.join(header)
np.savetxt('output.csv', output, fmt='%s', delimiter=',', header = header, comments='')
